import SwiftUI

@available(iOS 17.0, *)
@main
struct MyApp: App {
    @State private var navigationManager = StoryNavigationManager()
    @State private var soundManager = SoundManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.black
                
                NavigationStack(path: $navigationManager.path) {
                    HeadPhoneCheckView()
                        .navigationDestination(for: StoryStep.self) { step in
                            destinationView(for: step)
                        }
                }
                .environment(navigationManager)
                .environment(soundManager)
                .navigationBarBackButtonHidden(true)
            }
            .ignoresSafeArea()
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                soundManager.pauseAmbient()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                soundManager.resumeAmbient()
            }
        }
    }
    
    /// 모든 StoryStep -> View 라우팅 여기서 관리
    @ViewBuilder
    private func destinationView(for step: StoryStep) -> some View {
        switch step {
        case .headPhoneCheck:
            HeadPhoneCheckView()
        case .intro:
            StoryMessageView(currentStep: step)
        case .scene(let number, let phase):
            switch phase {
            case .dialogue:
                SceneDialogueView(sceneNumber: number, currentStep: step)
            case .quiz:
                SceneQuizView(sceneNumber: number, currentStep: step)
            case .tts:
                SceneTTSView(sceneNumber: number, currentStep: step)
            }
            
        case .outro:
//            StoryMessageView(currentStep: step)
            OutroDialogueView(currentStep: step)
        }
    }
}
