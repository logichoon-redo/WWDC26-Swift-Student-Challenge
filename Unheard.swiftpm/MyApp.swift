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
    
    @ViewBuilder
    private func destinationView(for step: StoryStep) -> some View {
        StoryMessageView(currentStep: step)
    }
}
