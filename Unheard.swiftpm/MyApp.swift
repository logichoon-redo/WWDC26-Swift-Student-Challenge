import SwiftUI

@available(iOS 17.0, *)
@main
struct MyApp: App {
    @State private var navigationManager = StoryNavigationManager()
    @State private var soundManager = SoundManager()
    @State private var languageManager = LanguageManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.black
                
                
                destinationView(for: navigationManager.currentStep)
                                    .id(navigationManager.currentStep)
                                    
                Color.black
                    .opacity(navigationManager.isTransitioning ? 1 : 0)
                    .allowsHitTesting(false)
            }
            .ignoresSafeArea()
            .environment(navigationManager)
            .environment(soundManager)
            .environment(languageManager)
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
            OutroDialogueView(currentStep: step)
        }
    }
}
