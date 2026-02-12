import SwiftUI

struct ContentView: View {
    
    @State private var simulator = SoundManager()
    @State private var isPlaying = false
    @State private var isReady = false
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("🎧 난청 시뮬레이터 테스트")
                .font(.title2)
                .bold()
            
            // ✅ TTS 테스트 버튼
            Button {
                Task {
                    await simulator.speak(text: "Number 37, your Americano is ready!", rate: 0.53)
                }
            } label: {
                Label("TTS 재생", systemImage: "speaker.wave.2")
                    .font(.headline)
                    .padding()
                    .background(isReady ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!isReady)
            
            // ✅ 환경 소음 테스트 (파일 필요)
            Button {
                if isPlaying {
                    simulator.stop()
                } else {
                    // ✅ 프로젝트에 "cafe_noise.mp3" 파일 추가 필요
                    simulator.playAmbient(named: "cafe_noise", ext: "aac")
                }
                isPlaying.toggle()
            } label: {
                Label(isPlaying ? "소음 중지" : "환경 소음 재생",
                      systemImage: isPlaying ? "stop.fill" : "waveform")
                .font(.headline)
                .padding()
                .background(isPlaying ? Color.red : Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(!isReady)
        
            // ✅ 볼륨 조절 슬라이더
            VStack(alignment: .leading) {
                Text("환경 소음 볼륨: \(Int(simulator.ambientVolume * 100))%")
                Slider(value: Binding(
                    get: { simulator.ambientVolume },
                    set: { simulator.ambientVolume = $0 }
                ), in: 0...1)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .task {
            await simulator.setup()
            isReady = true
        }
    }
}

