//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 3/2/26.
//

import SwiftUI

enum AppLanguage: String, CaseIterable {
    case english = "EN"
    case korean = "KR"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .korean: return "한국어"
        }
    }
    
    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .korean: return "🇰🇷"
        }
    }
    
    var ttsLanguage: String {
        switch self {
        case .english: return "en-US"
        case .korean: return "ko-KR"
        }
    }
}

@available(iOS 17.0, *)
@Observable
class LanguageManager {
    var current: AppLanguage
    
    init() {
        let preferred = Locale.preferredLanguages.first ?? "en"
        if preferred.hasPrefix("ko") {
            current = .korean
        } else {
            current = .english
        }
    }
    
    var messages: [StoryStep: StoryInfo] {
        switch current {
        case .english: return StoryDataEN.messages
        case .korean: return StoryDataKR.messages
        }
    }
    
    var quizzes: [StoryStep: QuizInfo] {
        switch current {
        case .english: return StoryDataEN.quizzes
        case .korean: return StoryDataKR.quizzes
        }
    }
    
    func toggle() {
        current = (current == .english) ? .korean : .english
    }
    
    // MARK: - For HardCoding
    var headphoneGuide: String {
        current == .korean
        ? "더 몰입감 있는\n경험을 위해\n헤드폰을 사용해주세요. 🎧"
        : "For a more immersive\nexperience, please use\nheadphones. 🎧"
    }
    
    var skipHint: String {
        current == .korean
        ? "아무 곳이나 탭하면 애니메이션을 건너뜁니다"
        : "Tap anywhere to skip animations"
    }
    
    var continueButton: String {
        current == .korean ? "계속하기" : "Continue"
    }
    
    var experienceAgain: String {
        current == .korean ? "다시 체험하기" : "Experience Again"
    }
    
    var tryAgain: String {
        current == .korean ? "다시 풀기" : "Try again"
    }
    
    var needHint: String {
        current == .korean ? "💡 힌트가 필요한가요?" : "💡 Need a hint?"
    }
    
    var replayButton: String {
        current == .korean
        ? "죄송한데, 다시 말해주실 수 있나요?"
        : "Sorry, could you say that again?"
    }
    
    var prevButton: String {
        current == .korean ? "이전" : "PREV"
    }
    
    var nextButton: String {
        current == .korean ? "다음" : "NEXT"
    }
    
    var needAHint: String {
        current == .korean ? "💡 힌트가 필요해요?" : "💡 Need a hint?"
    }
    
    func locationName(for config: SceneConfig) -> String {
        current == .korean ? config.locationNameKR : config.locationName
    }
}
