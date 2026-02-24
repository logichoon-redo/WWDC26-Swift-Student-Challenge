import SwiftUI

@available(iOS 17.0, *)
struct HeadPhoneCheckView: View {
    @State private var showButton = false
    @Environment(StoryNavigationManager.self) private var navigationManager
    
    let fullText = """
For a more immersive
experience, please use
headphones 🎧.
"""
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    Color.black
                    
                    VStack(spacing: 50) {
                        Spacer()
                            .frame(height: 50)
                        
                        Image(systemName: "waveform")
                            .font(.system(size: 70))
                            .foregroundStyle(.white)
                            .sfSymvolAnimated(true)
                        
                        TypingTextView(text: fullText,
                                       width: geo.size.width,
                                       height: geo.size.height * 0.3,
                                       typingSpeed: 20_000_000) { completed in
                            if completed {
                                withAnimation(.easeOut(duration: 0.3).delay(0.3)) {
                                    showButton = true
                                }
                            }
                        }
                        
                        Button("Continue") {
                            navigationManager.navigationTo(step: .intro(page: 4))
                            // TODO: intro(page: 1)으로 되돌려 놓기. (테스트를 위해 page 4로 둠)
                        }
                        .buttonStyle(.bordered)
                        .opacity(showButton ? 1 : 0)
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}
