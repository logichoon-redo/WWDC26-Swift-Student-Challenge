import SwiftUI

@available(iOS 17.0, *)
@main
struct MyApp: App {
    @State private var navigationManager = StoryNavigationManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationManager.path) {
                HeadPhoneCheckView()
                    .navigationDestination(for: StoryStep.self) { step in
                        destinationView(for: step)
                    }
            }
            .environment(navigationManager)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    @ViewBuilder
    private func destinationView(for step: StoryStep) -> some View {
        switch step {
        case .intro:
            IntroView(fullText: """
        Hi, I'm Gosan ⛰️.
        |
        I'm a developer 
        from South Korea.
        |
        I love rare plants, bass guitar,
        and building apps that matter.
        """)
        case .tutorial:
            HeadPhoneCheckView()
        }
    }
}
