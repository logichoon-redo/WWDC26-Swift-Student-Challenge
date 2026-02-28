//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/25/26.
//

import SwiftUI

@available(iOS 17.0, *)
struct OutroDialogueView: View {
    @State private var showButton = false
    @Environment(StoryNavigationManager.self) private var navigationManager
    @Environment(SoundManager.self) private var soundManager
    let currentStep: StoryStep

    private var storyInfo: StoryInfo? {
        StoryData.messages[currentStep]
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                currentStep.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    if let story = storyInfo {
                        TypingTextView(text: story.text,
                                       width: max(0, geo.size.width - (.defaultSpacing * 2)),
                                       height: max(0, geo.size.height * 0.25),
                                       alignment: .leading,
                                       baseTextColor: currentStep.textColor,
                                       onComplete: { completed in
                            if completed {
                                withAnimation(.easeOut(duration: 0.3).delay(0.3)) {
                                    showButton = true
                                }
                            }
                        })
                        .padding(.horizontal, .defaultSpacing)
                        
                        CharacterFaceView(character: story.expression,
                                          gradientColor: currentStep.backgroundColor)
                        
                        Spacer()
                        
                        Button {
                            soundManager.stop()
                            navigationManager.reset()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Experience Again")
                            }
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white.opacity(0.8))
                        }
                        .opacity(showButton ? 1 : 0)
                        .disabled(!showButton)
                        .padding(.bottom, .largeSpacing)
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                showButton = false
            }
            .task {
                guard let storyInfo else { return }
                let suffix = String(storyInfo.id.suffix(2))
                
                switch suffix {
                case "ls", "o1", "o2", "o3":
                    await soundManager.fadeOutAmbient()
                default: break
                }
            }
        }
    }
}
