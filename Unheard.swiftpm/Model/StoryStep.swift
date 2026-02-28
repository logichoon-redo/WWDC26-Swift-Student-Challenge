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

extension StoryStep {
    var backgroundBrightness: Int {
        switch self {
        case .intro(let page):
            switch page {
            case 5: return 1
            case 6: return 2
            case 7: return 3
            default: return 0
            }
        case .scene:
            if let info = StoryData.messages[self], info.id.hasPrefix("bc") {
                return 3
            }
            if let quiz = StoryData.quizzes[self], quiz.id.hasPrefix("bc") {
                return 3
            }
            return 0
        case .outro: return 3
        default: return 0
        }
    }
    
    var backgroundColor: Color {
        switch backgroundBrightness {
        case 1: return Color(white: 0.25)
        case 2: return Color(white: 0.5)
        case 3: return Color.white
        default: return Color.black
        }
    }
    
    var textColor: Color {
        backgroundBrightness >= 3 ? .black : .white
    }
    
    var accentTextColor: Color {
        backgroundBrightness >= 3 ? .orange : .yellow
    }
    
    var glowColor: Color {
        backgroundBrightness >= 3 ? .black : .white
    }
}
