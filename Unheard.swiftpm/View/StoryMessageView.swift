//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/12/26.
//

import SwiftUI

@available(iOS 17.0, *)
struct StoryMessageView: View {
    @State private var showButton = false
    @Environment(StoryNavigationManager.self) private var navigationManager
    @Environment(SoundManager.self) private var soundManager
    
    let currentStep: StoryStep
    
    var storyInfo: StoryInfo? {
        StoryData.messages[currentStep]
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    if let story = storyInfo {
                        TypingTextView(text: story.text,
                                       width: geo.size.width,
                                       height: geo.size.height * 0.3,
                                       onComplete: { completed in
                            if completed {
                                withAnimation(.easeOut(duration: 0.3).delay(0.3)) {
                                    showButton = true
                                }
                            }
                        })
                        
                        CharacterFaceView(character: story.expression)
                        
                        PageNavigationBar(showPrev: story.showPrevButton,
                                          showNext: story.showNextButton && showButton,
                                          prevText: story.prevButtonText,
                                          nextText: story.nextButtonText,
                                          prevDestination: {
                            navigationManager.goBack()
                        },
                                          nextDestination: {
                            navigationManager.navigationTo(step: story.nextStep)
                            if story.nextStep == .scene(number: 1, phase: .dialogue(page: 1)) {
                                Task {
                                    await soundManager.fadeOutAmbient()
                                }
                            }
                        })
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .onAppear {
            showButton = false
            if currentStep == .intro(page: 1) || currentStep == .intro(page: 7) {
                Task {
                    await soundManager.setup()
                    
                    soundManager.playAmbient(named: "calmAmbient", ext: "mp3")
                }
            }
        }
    }
}
