import SwiftUI

@available(iOS 17.0, *)
struct HeadPhoneCheckView: View {
    @State private var showButton = false
    @Environment(StoryNavigationManager.self) private var navigationManager
    @Environment(LanguageManager.self) private var langManager
    
    var body: some View {
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
                    
                    TypingTextView(text: langManager.headphoneGuide,
                                   width: geo.size.width,
                                   height: geo.size.height * 0.3,
                                   typingSpeed: 20_000_000) { completed in
                        if completed {
                            withAnimation(.easeOut(duration: 0.3).delay(0.3)) {
                                showButton = true
                            }
                        }
                    }
                                   .id(langManager.current)
                    
                    Text(langManager.skipHint)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.4))
                        .opacity(showButton ? 1 : 0)
                        .phaseAnimator([0.4, 1.0]) { content, phase in
                            content.opacity(phase)
                        } animation: { _ in
                                .easeInOut(duration: 1.5)
                        }
                    
                    Button(langManager.continueButton) {
                        navigationManager.navigationTo(step: .intro(page: 1))
                        // TODO: intro(page: 1)으로 되돌려 놓기. (테스트를 위해 page 4로 둠)
                    }
                    .buttonStyle(.bordered)
                    .opacity(showButton ? 1 : 0)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            langManager.toggle()
                        } label: {
                            HStack(spacing: 6) {
                                Text(langManager.current.flag)
                                Text(langManager.current.rawValue)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(.white.opacity(0.1))
                            )
                        }
                        .padding(.trailing, .defaultSpacing)
                        .padding(.top, 60)
                    }
                    Spacer()
                }
            }
            .ignoresSafeArea()
        }
    }
}
