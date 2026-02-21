//
//  SwiftUIView.swift
//  Unheard
//
//  Created by 이치훈 on 2/16/26.
//

import SwiftUI

@available(iOS 17.0, *)
struct SceneDialogueView: View {
    @State private var showButton = false
    @Environment(StoryNavigationManager.self) private var navigationManager
    @Environment(SoundManager.self) private var soundManager
    let sceneNumber: Int
    let currentStep: StoryStep
    
    private var config: SceneConfig {
        SceneConfig.config(for: sceneNumber)
    }
    
    private var storyInfo: StoryInfo? {
        StoryData.messages[currentStep]
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                SceneBackgroundView(background: config.background,
                                    isBlurred: false,
                                    showBottomGradient: true)
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    if let story = storyInfo {
                        TypingTextView(text: story.text,
                                       width: max(0, geo.size.width - (.defaultSpacing * 2)),
                                       height: max(0, geo.size.height * 0.2),
                                       alignment: .leading,
                                       onComplete: { completed in
                            if completed {
                                withAnimation(.easeOut(duration: 0.3).delay(0.3)) {
                                    showButton = true
                                }
                            }
                        })
                        .padding(.horizontal, .defaultSpacing)
                        .padding(.bottom, .largeSpacing)
                        
                        PageNavigationBar(showPrev: story.showPrevButton,
                                          showNext: story.showNextButton && showButton,
                                          prevText: story.prevButtonText,
                                          nextText: story.nextButtonText,
                                          prevDestination: { navigationManager.goBack() },
                                          nextDestination: {
                            navigationManager.navigationTo(step: story.nextStep)
                        })
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
            .task {
                guard let storyInfo else { return }
                let suffix = String(storyInfo.id.suffix(2))
                
                switch suffix {
                case "d1":
                    if let audio = config.ambientAudio {
                        await soundManager.setup()
                        
                        soundManager.playAmbient(named: audio.audioName)
                    }
                case "ls":
                    await soundManager.fadeOutAmbient()
                default: break
                }
            }
        }
    }
}
