import SwiftUI

@available(iOS 17.0, *)
@main
struct MyApp: App {
    @State private var navigationManager = StoryNavigationManager()
    
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
                .navigationBarBackButtonHidden(true)
            }
            .ignoresSafeArea()
        }
    }
    
    /// 모든 StoryStep -> View 라우팅 여기서 관리
    @ViewBuilder
    private func destinationView(for step: StoryStep) -> some View {
//        StoryMessageView(currentStep: step)
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
                EmptyView()
            case .tts:
                SceneTTSView(sceneNumber: number, currentStep: step)
            }
            
        case .outro:
            EmptyView()
        }
    }
}
