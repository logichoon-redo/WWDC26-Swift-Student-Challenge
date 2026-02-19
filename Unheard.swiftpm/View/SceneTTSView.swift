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
    let sceneNumber: Int
    let currentStep: StoryStep
    
    @State private var showCharacter: Bool = false
    
    private var config: SceneConfig {
        SceneConfig.config(for: sceneNumber)
    }
    
    var body: some View {
        ZStack {
            SceneBackgroundView(background: SceneConfig.config(for: sceneNumber).background,
                                isBlurred: true,
                                showBottomGradient: false)
            
            if showCharacter {
                CharacterFaceView(character: config.npc,
                                  showGradient: false)
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .task {
            try? await Task.sleep(for: .seconds(0.5))
            withAnimation(.easeIn(duration: 0.3)) {
                showCharacter = true
            }
        }
    }
}
