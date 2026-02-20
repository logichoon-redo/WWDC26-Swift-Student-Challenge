//
//  SoundManager.swift
//  Unheard
//
//  Created by 이치훈 on 2/12/26.
//

@preconcurrency
import AVFoundation
import AudioToolbox
import Accelerate
import Observation

struct UncheckedSendable<T>: @unchecked Sendable {
    let value: T
}

// MARK: - 난청 시뮬레이터 (TTS + 환경소음 믹싱)
@available(iOS 17.0, *)
@Observable
final class SoundManager: NSObject, @unchecked Sendable {
    
    // MARK: Audio Engine Components
    private let engine = AVAudioEngine()
    private let eq = AVAudioUnitEQ(numberOfBands: 5)
    private let ttsPlayerNode = AVAudioPlayerNode()
    private let ambientPlayerNode = AVAudioPlayerNode()
    private let mixer = AVAudioMixerNode()
    
    // Dynamics Processor
    private var dynamicsProcessor: AVAudioUnit?

    // Dynamics 설정값
    private let dynamicsThreshold: Float = -30
    private let dynamicsHeadRoom: Float = 5
    private let dynamicsExpansionRatio: Float = 4
    private let dynamicsAttackTime: Float = 0.001
    private let dynamicsReleaseTime: Float = 0.05
    
    // MARK: TTS
    private let synthesizer = AVSpeechSynthesizer()
    private var ttsBuffers: [AVAudioPCMBuffer] = []
    
    // MARK: FFT Processing
    private var fftSetup: FFTSetup?
    private let fftSize = 1024
    private let log2n: vDSP_Length
    
    // MARK: Buffers
    private var realBuffer: [Float]
    private var imagBuffer: [Float]
    private var tempReal: [Float]
    private var tempImag: [Float]
    
    // 난청 필터 강도
    private let eqGains: [Float] = [-10, -25, -40, -55, -65]
    private let blurAmount: Float = 2
    
    // MARK: Observable Properties
    // didSet 제거 - @Observable과 함께 쓸 때 외부 객체 조작은 별도 메서드로 분리
    var ttsVolume: Float = 1.0
    var ambientVolume: Float = 0.5
    
    // SwiftUI 바인딩용 오디오 레벨 (0.0 ~ 1.0)
    // audioLevelHandler 콜백 대신 @Observable 프로퍼티로 직접 관리
    var audioLevel: Float = 0
    
    // MARK: - Initialization
    override init() {
        log2n = vDSP_Length(log2(Float(fftSize)))
        
        realBuffer = [Float](repeating: 0, count: fftSize)
        imagBuffer = [Float](repeating: 0, count: fftSize)
        tempReal = [Float](repeating: 0, count: fftSize)
        tempImag = [Float](repeating: 0, count: fftSize)
        
        fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2))
        
        super.init()
    }
    
    deinit {
        if let setup = fftSetup {
            vDSP_destroy_fftsetup(setup)
        }
        engine.stop()
    }
    
    func setup() async {
        dynamicsProcessor = await createDynamicsProcessor()
        setupAudioGraph()
        print("✅ HearingLossSimulator 초기화 완료")
    }
    
    // MARK: - Volume Control
    // didSet 대신 명시적 메서드로 분리 - @Observable 환경에서 안전
    func setTTSVolume(_ volume: Float) {
        ttsVolume = volume
        ttsPlayerNode.volume = volume
    }
    
    func setAmbientVolume(_ volume: Float) {
        ambientVolume = volume
        ambientPlayerNode.volume = volume
    }
    
    // MARK: - RMS 계산 (오디오 레벨 측정)
    private func calculateRMS(from buffer: AVAudioPCMBuffer) -> Float {
        guard let channelData = buffer.floatChannelData else { return 0 }
        let frameLength = vDSP_Length(buffer.frameLength)
        var rms: Float = 0
        vDSP_measqv(channelData[0], 1, &rms, frameLength)
        return sqrt(rms)
    }
    
    // MARK: Dynamics Processor 생성
    private func createDynamicsProcessor() async -> AVAudioUnit? {
        let componentDescription = AudioComponentDescription(
            componentType: kAudioUnitType_Effect,
            componentSubType: kAudioUnitSubType_DynamicsProcessor,
            componentManufacturer: kAudioUnitManufacturer_Apple,
            componentFlags: 0,
            componentFlagsMask: 0
        )
        
        let wrapped: UncheckedSendable<AVAudioUnit>? = await withCheckedContinuation { continuation in
            AVAudioUnit.instantiate(with: componentDescription, options: []) { [weak self] audioUnit, error in
                if let error = error {
                    print("❌ Dynamics Processor 생성 실패: \(error)")
                    continuation.resume(returning: nil)
                    return
                }
                
                if let au = audioUnit?.auAudioUnit {
                    self?.configureDynamicsParameters(au)
                }
                
                if let audioUnit = audioUnit {
                    continuation.resume(returning: UncheckedSendable(value: audioUnit))
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
        
        return wrapped?.value
    }
    
    // MARK: Dynamics 파라미터 설정
    private func configureDynamicsParameters(_ au: AUAudioUnit) {
        guard let parameterTree = au.parameterTree else { return }
        
        let paramThreshold: AUParameterAddress = 0
        let paramHeadRoom: AUParameterAddress = 1
        let paramExpansionRatio: AUParameterAddress = 2
        let paramAttackTime: AUParameterAddress = 4
        let paramReleaseTime: AUParameterAddress = 5
        let paramMasterGain: AUParameterAddress = 6
        
        parameterTree.parameter(withAddress: paramThreshold)?.value = dynamicsThreshold
        parameterTree.parameter(withAddress: paramHeadRoom)?.value = dynamicsHeadRoom
        parameterTree.parameter(withAddress: paramExpansionRatio)?.value = dynamicsExpansionRatio
        parameterTree.parameter(withAddress: paramAttackTime)?.value = dynamicsAttackTime
        parameterTree.parameter(withAddress: paramReleaseTime)?.value = dynamicsReleaseTime
        parameterTree.parameter(withAddress: paramMasterGain)?.value = 5
        
        print("✅ Dynamics 파라미터 설정 완료")
    }
    
    // MARK: - Audio Graph Setup
    private func setupAudioGraph() {
        /*
         ✅ Audio Graph 구조:
         
         TTS PlayerNode ──┐
                          ├──→ Mixer ──→ EQ ──→ [Spectral Blur + RMS Tap] ──→ Output
         Ambient PlayerNode ─┘
         
         Dynamics가 있을 경우:
         TTS PlayerNode ──┐
                          ├──→ Mixer ──→ EQ ──→ Dynamics ──→ [Spectral Blur + RMS Tap] ──→ Output
         Ambient PlayerNode ─┘
         */
        
        engine.attach(ttsPlayerNode)
        engine.attach(ambientPlayerNode)
        engine.attach(mixer)
        engine.attach(eq)
        
        let format = engine.mainMixerNode.outputFormat(forBus: 0)
        
        engine.connect(ttsPlayerNode, to: mixer, format: format)
        engine.connect(ambientPlayerNode, to: mixer, format: format)
        engine.connect(mixer, to: eq, format: format)
        
        if let dynamics = dynamicsProcessor {
            engine.attach(dynamics)
            engine.connect(eq, to: dynamics, format: format)
            engine.connect(dynamics, to: engine.mainMixerNode, format: format)
            
            dynamics.installTap(onBus: 0,
                                 bufferSize: AVAudioFrameCount(fftSize),
                                 format: format) { [weak self] buffer, _ in
                self?.applySpectralBlur(to: buffer)
                
                let level = self?.calculateRMS(from: buffer) ?? 0
                let normalized = min(level * 10, 1.0)
                
                Task { @MainActor [weak self] in
                    self?.audioLevel = normalized
                }
            }
            print("✅ Audio Graph (Dynamics 포함)")
        } else {
            engine.connect(eq, to: engine.mainMixerNode, format: format)
            
            eq.installTap(onBus: 0,
                          bufferSize: AVAudioFrameCount(fftSize),
                          format: format) { [weak self] buffer, _ in
                self?.applySpectralBlur(to: buffer)
                
                let level = self?.calculateRMS(from: buffer) ?? 0
                let normalized = min(level * 10, 1.0)
                
                Task { @MainActor [weak self] in
                    self?.audioLevel = normalized
                }
            }
            print("⚠️ Audio Graph (Dynamics 없이)")
        }
        
        ttsPlayerNode.volume = ttsVolume
        ambientPlayerNode.volume = ambientVolume
        
        setupEQ()
    }
    
    // MARK: - EQ 설정 (고음 슬로프)
    private func setupEQ() {
        let frequencies: [Float] = [1000, 2000, 4000, 8000, 12000]
        
        for (i, band) in eq.bands.enumerated() {
            band.frequency = frequencies[i]
            band.bandwidth = 1.0
            band.gain = eqGains[i]
            band.bypass = false
            band.filterType = .parametric
        }
    }
    
    // MARK: - Spectral Blur
    private func applySpectralBlur(to buffer: AVAudioPCMBuffer) {
        guard let fftSetup = fftSetup,
              let channelData = buffer.floatChannelData,
              blurAmount > 0 else { return }
        
        let frameLength = Int(buffer.frameLength)
        let channelCount = Int(buffer.format.channelCount)
        let processLength = min(frameLength, fftSize)
        
        let kernelSize = max(1, min(Int(blurAmount * 10), 20))
        
        for channel in 0..<channelCount {
            let data = channelData[channel]
            
            realBuffer = [Float](repeating: 0, count: fftSize)
            imagBuffer = [Float](repeating: 0, count: fftSize)
            
            for i in 0..<processLength {
                realBuffer[i] = data[i]
            }
            
            realBuffer.withUnsafeMutableBufferPointer { realPtr in
                imagBuffer.withUnsafeMutableBufferPointer { imagPtr in
                    var splitComplex = DSPSplitComplex(
                        realp: realPtr.baseAddress!,
                        imagp: imagPtr.baseAddress!
                    )
                    
                    vDSP_fft_zip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))
                    
                    tempReal = Array(realPtr)
                    tempImag = Array(imagPtr)
                    
                    let halfKernel = kernelSize / 2
                    let startIdx = halfKernel + 1
                    let endIdx = fftSize/2 - halfKernel - 1
                    
                    for i in startIdx..<endIdx {
                        var sumReal: Float = 0
                        var sumImag: Float = 0
                        
                        for k in -halfKernel...halfKernel {
                            sumReal += tempReal[i + k]
                            sumImag += tempImag[i + k]
                        }
                        
                        realPtr[i] = sumReal / Float(kernelSize)
                        imagPtr[i] = sumImag / Float(kernelSize)
                        
                        let mirrorIdx = fftSize - i
                        realPtr[mirrorIdx] = realPtr[i]
                        imagPtr[mirrorIdx] = -imagPtr[i]
                    }
                    
                    vDSP_fft_zip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_INVERSE))
                }
            }
            
            var scale = 1.0 / Float(fftSize)
            realBuffer.withUnsafeMutableBufferPointer { realPtr in
                vDSP_vsmul(realPtr.baseAddress!, 1, &scale, data, 1, vDSP_Length(processLength))
            }
        }
    }
    
    // MARK: - Public API
    
    /// TTS 음성 재생
    func speak(text: String, rate: Float = AVSpeechUtteranceDefaultSpeechRate) async {
        ttsBuffers.removeAll()
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = rate
        
        await withCheckedContinuation { continuation in
            var hasResumed = false
            
            synthesizer.write(utterance) { [weak self] buffer in
                guard let self = self,
                      let pcmBuffer = buffer as? AVAudioPCMBuffer else { return }
                
                if pcmBuffer.frameLength > 0 {
                    self.ttsBuffers.append(pcmBuffer)
                } else {
                    if !hasResumed {
                        hasResumed = true
                        continuation.resume()
                    }
                }
            }
        }
        
        playTTS()
    }
    
    /// 환경 소음 재생 (루프)
    func playAmbient(named fileName: String, ext: String = "aac", subdir: String? = nil) {
        func urls(in bundle: Bundle, name: String, exts: [String], subdir: String?) -> [URL] {
            exts.compactMap { bundle.url(forResource: name, withExtension: $0, subdirectory: subdir) }
        }

        var exts: [String] = []
        if !ext.isEmpty { exts.append(ext) }
        exts.append(contentsOf: ["aac", "m4a", "mp3", "wav", "caf"])

        var candidates: [URL] = []

        #if SWIFT_PACKAGE
        candidates.append(contentsOf: urls(in: Bundle.module, name: fileName, exts: exts, subdir: subdir))
        #endif
        candidates.append(contentsOf: urls(in: Bundle(for: SoundManager.self), name: fileName, exts: exts, subdir: subdir))
        candidates.append(contentsOf: urls(in: .main, name: fileName, exts: exts, subdir: subdir))

        guard let url = candidates.first else {
            print("❌ 환경 소음 파일 없음: \(fileName).\(ext) (subdir: \(subdir ?? "nil"))")
            return
        }

        do {
            let file = try AVAudioFile(forReading: url)
            ambientPlayerNode.scheduleFile(file, at: nil) { [weak self] in
                self?.playAmbient(named: fileName, ext: ext, subdir: subdir)
            }
            startEngineIfNeeded()
            ambientPlayerNode.play()
        } catch {
            print("❌ 환경 소음 재생 실패: \(error)")
        }
    }
    
    /// TTS 버퍼 재생
    func playTTS() {
        guard !ttsBuffers.isEmpty else { return }
        
        for buffer in ttsBuffers {
            if let converted = convertBuffer(buffer) {
                ttsPlayerNode.scheduleBuffer(converted)
            }
        }
        
        startEngineIfNeeded()
        ttsPlayerNode.play()
    }
    
    private func convertBuffer(_ buffer: AVAudioPCMBuffer) -> AVAudioPCMBuffer? {
        let engineFormat = engine.mainMixerNode.outputFormat(forBus: 0)
        
        if buffer.format == engineFormat {
            return buffer
        }
        
        guard let converter = AVAudioConverter(from: buffer.format, to: engineFormat) else {
            return nil
        }
        
        let ratio = engineFormat.sampleRate / buffer.format.sampleRate
        let newFrameCount = AVAudioFrameCount(Double(buffer.frameLength) * ratio)
        
        guard let convertedBuffer = AVAudioPCMBuffer(pcmFormat: engineFormat,
                                                      frameCapacity: newFrameCount) else {
            return nil
        }
        
        var error: NSError?
        converter.convert(to: convertedBuffer, error: &error) { _, outStatus in
            outStatus.pointee = .haveData
            return buffer
        }
        
        return error == nil ? convertedBuffer : nil
    }
    
    private func startEngineIfNeeded() {
        guard !engine.isRunning else { return }
        try? engine.start()
    }
    
    func stop() {
        ttsPlayerNode.stop()
        ambientPlayerNode.stop()
    }
}
