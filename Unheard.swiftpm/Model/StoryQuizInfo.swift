//
//  StoryInfo.swift
//  Unheard
//
//  Created by 이치훈 on 3/3/26.
//


// MARK: - StoryInfo
struct StoryInfo {
    let id: String
    let text: String // 대본
    let expression: CharacterExpression // Gosan 표정
    let nextStep: StoryStep // 다음 화면
    let showPrevButton: Bool
    let showNextButton: Bool
    let prevButtonText: String
    let nextButtonText: String
    
    init(id: String,
         text: String,
         expression: CharacterExpression = .none,
         nextStep: StoryStep = .headPhoneCheck,
         showPrevButton: Bool = true,
         showNextButton: Bool = true,
         prevButtonText: String = "PREV",
         nextButtonText: String = "NEXT") {
        self.id = id
        self.text = text
        self.expression = expression
        self.nextStep = nextStep
        self.showPrevButton = showPrevButton
        self.showNextButton = showNextButton
        self.prevButtonText = prevButtonText
        self.nextButtonText = nextButtonText
    }
}

// MARK: - QuizInfo
struct QuizInfo {
    let id: String
    let question: String
    let options: [String]
    let correctIndices: Set<Int>
    let correctSteps: [Int: StoryStep]
    let wrongSteps: [Int: StoryStep]
    let defaultWrongStep: StoryStep
    let hint: String?
    let quizType: QuizType
    let hintCards: (title: String, cards: [HintCard])?
    
    func nextStep(for selectedIndex: Int) -> StoryStep {
        if let step = correctSteps[selectedIndex] {
            return step
        }
        
        if let step = wrongSteps[selectedIndex] {
            return step
        }
        
        return defaultWrongStep
    }
    
    func isCorrectIndices(selectedIndex: Int) -> Bool {
        return correctIndices.contains(selectedIndex)
    }
}