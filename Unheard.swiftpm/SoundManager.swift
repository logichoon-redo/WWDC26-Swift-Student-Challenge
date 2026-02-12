//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/12/26.
//

@preconcurrency
import AVFoundation
import AudioToolbox
import Accelerate

private struct UncheckedSendable<T>: @unchecked Sendable {
    let value: T
}

// MARK: - 난청 시뮬레이터 (TTS + 환경소음 믹싱)
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
    
    // 믹싱 볼륨
    var ttsVolume: Float = 1.0 {
        didSet { ttsPlayerNode.volume = ttsVolume }
    }
    var ambientVolume: Float = 0.5 {
        didSet { ambientPlayerNode.volume = ambientVolume }
    }
    
    // MARK: - Initialization
    override init() {
        log2n = vDSP_Length(log2(Float(fftSize)))
        
        realBuffer = [Float](repeating: 0, count: fftSize)
        imagBuffer = [Float](repeating: 0, count: fftSize)
        tempReal = [Float](repeating: 0, count: fftSize)
        tempImag = [Float](repeating: 0, count: fftSize)
        
        fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2))
        
        super.init()
        
//        setupAudioGraph()
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
                
                // ✅ Wrapper로 감싸서 반환
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
         ✅ Audio Graph 구조 (Dynamics 제거):
         
         TTS PlayerNode ──┐
                          ├──→ Mixer ──→ EQ ──→ [Spectral Blur Tap] ──→ Output
         Ambient PlayerNode ─┘
         */
        
        engine.attach(ttsPlayerNode)
        engine.attach(ambientPlayerNode)
        engine.attach(mixer)
        engine.attach(eq)
        
        let format = engine.mainMixerNode.outputFormat(forBus: 0)
        
        // TTS + Ambient → Mixer → EQ → Output
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
            }
            print("✅ Audio Graph (Dynamics 포함)")
        } else {
            engine.connect(eq, to: engine.mainMixerNode, format: format)
            
            // Spectral Blur Tap (EQ 출력에 설치)
            eq.installTap(onBus: 0,
                          bufferSize: AVAudioFrameCount(fftSize),
                          format: format) { [weak self] buffer, _ in
                self?.applySpectralBlur(to: buffer)
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
                    
                    // Forward FFT
                    vDSP_fft_zip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))
                    
                    // Spectral Smearing
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
                        
                        // 대칭 성분
                        let mirrorIdx = fftSize - i
                        realPtr[mirrorIdx] = realPtr[i]
                        imagPtr[mirrorIdx] = -imagPtr[i]
                    }
                    
                    // Inverse FFT
                    vDSP_fft_zip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_INVERSE))
                }
            }
            
            // ✅ 스케일링 및 결과 복사
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
        // TODO: 재생 중인 engine 정지 로직 추가
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = rate
        
        await withCheckedContinuation { continuation in
            var hasresumeed = false
            
            synthesizer.write(utterance) { [weak self] buffer in
                guard let self = self,
                      let pcmBuffer = buffer as? AVAudioPCMBuffer else { return }
                
                if pcmBuffer.frameLength > 0 {
                    self.ttsBuffers.append(pcmBuffer)
                } else {
                    if !hasresumeed {
                        hasresumeed = true
                        continuation.resume()
                    }
                }
            }
        }
        
        playTTS()
    }
    
    /// 환경 소음 재생 (루프)
    func playAmbient(named fileName: String, ext: String = "aac", subdir: String? = nil) {
        // Helper to get candidate URLs from a bundle
        func urls(in bundle: Bundle, name: String, exts: [String], subdir: String?) -> [URL] {
            exts.compactMap { bundle.url(forResource: name, withExtension: $0, subdirectory: subdir) }
        }

        // Prefer the requested ext, but try common fallbacks as well
        var exts: [String] = []
        if !ext.isEmpty { exts.append(ext) }
        exts.append(contentsOf: ["aac", "m4a", "mp3", "wav", "caf"]) // fallbacks

        var candidates: [URL] = []

        // 1) SwiftPM module bundle (if available at runtime)
        #if SWIFT_PACKAGE
        candidates.append(contentsOf: urls(in: Bundle.module, name: fileName, exts: exts, subdir: subdir))
        #endif

        // 2) Bundle for this class (works for app/framework targets)
        candidates.append(contentsOf: urls(in: Bundle(for: SoundManager.self), name: fileName, exts: exts, subdir: subdir))

        // 3) Main bundle (as a last resort if file is copied to app target)
        candidates.append(contentsOf: urls(in: .main, name: fileName, exts: exts, subdir: subdir))

        guard let url = candidates.first else {
            let modulePath: String = {
                #if SWIFT_PACKAGE
                return Bundle.module.bundlePath
                #else
                return "(no Bundle.module)"
                #endif
            }()
            let classBundle = Bundle(for: SoundManager.self)
            let classBundlePath = classBundle.bundlePath
            let mainBundle = Bundle.main
            let mainPath = mainBundle.bundlePath

            print("❌ 환경 소음 파일 없음: \(fileName).\(ext) (subdir: \(subdir ?? "nil"))")
            print("   - Bundle.module: \(modulePath)")
            print("   - Class bundle : \(classBundlePath)")
            print("   - Main bundle  : \(mainPath)")

            // Try to enumerate a subset of resources in each bundle for debugging
            func listResources(in bundle: Bundle, prefix: String) {
                if let urls = try? FileManager.default.contentsOfDirectory(at: bundle.bundleURL, includingPropertiesForKeys: nil) {
                    let resourceLike = urls.filter { $0.pathExtension.lowercased().isEmpty == false }
                    let sample = resourceLike.prefix(20).map { $0.lastPathComponent }
                    print("   - \(prefix) contains (sample up to 20): \(sample)")
                } else {
                    print("   - \(prefix) resource listing failed")
                }
            }

            #if SWIFT_PACKAGE
            listResources(in: Bundle.module, prefix: "Bundle.module")
            #endif
            listResources(in: classBundle, prefix: "Class bundle")
            listResources(in: mainBundle, prefix: "Main bundle")

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

