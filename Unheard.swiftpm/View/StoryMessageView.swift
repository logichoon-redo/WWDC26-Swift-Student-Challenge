//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/12/26.
//

import SwiftUI

@available(iOS 17.0, *)
struct StoryMessageView: View {
    @Environment(StoryNavigationManager.self) private var navigationManager
    
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
                                       height: geo.size.height * 0.3,)
                        
                        GosanFaceView(expression: story.expression)
                        
                        PageNavigationBar(showPrev: story.showPrevButton,
                                          showNext: story.showNextButton,
                                          prevText: story.prevButtonText,
                                          nextText: story.nextButtonText,
                                          prevDestination: {
                            navigationManager.goBack()
                        },
                                          nextDestination: {
                            if let nextStep = story.nextStep {
                                navigationManager.navigationTo(step: nextStep)
                            }
                        })
                        .padding(.bottom, .largeSpacing)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
}
