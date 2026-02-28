//
//  StoryStep.swift
//  Unheard
//
//  Created by 이치훈 on 2/13/26.
//

import SwiftUI

enum ScenePhase: Hashable {
    case dialogue(page: Int)
    case quiz(page: Int)
    case tts
}

enum StoryStep: Hashable {
    case headPhoneCheck

    case intro(page: Int)
    
    case scene(number: Int, phase: ScenePhase)
    
    case outro(page: Int)
}
