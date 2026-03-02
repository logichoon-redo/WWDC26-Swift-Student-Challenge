//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/19/26.
//

import SwiftUI

@available(iOS 17.0, *)
struct SceneTTSView: View {
    @Environment(StoryNavigationManager.self) private var navigationManager
    @Environment(SoundManager.self) private var soundManager
    @Environment(LanguageManager.self) private var langManager
    let sceneNumber: Int
    let currentStep: StoryStep
    
    @State private var showCharacter: Bool = false
    
    private var config: SceneConfig {
        SceneConfig.config(for: sceneNumber)
    }
    private var storyInfo: StoryInfo? {
        langManager.messages[currentStep]
    }
    
    var body: some View {
        ZStack {
            SceneBackgroundView(background: SceneConfig.config(for: sceneNumber).background,
                                isBlurred: true,
                                showBottomGradient: false)
            
            if showCharacter {
                CharacterFaceView(character: config.npc,
                                  showGradient: false,
                                  glowLevel: soundManager.audioLevel)
                .transition(.opacity)
            }
        }
        .ignoresSafeArea()
        .task {
            try? await Task.sleep(for: .seconds(0.5))
            withAnimation(.easeIn(duration: 0.3)) {
                showCharacter = true
            }

            if let story = storyInfo {
                await soundManager.speak(text: story.text, language: langManager.current.ttsLanguage)
                
                try? await Task.sleep(for: .seconds(1))
                
                navigationManager.navigationTo(step: story.nextStep)
            }
        }
    }
}
