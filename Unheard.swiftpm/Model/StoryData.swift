//
//  StoryData.swift
//  Unheard
//
//  Created by 이치훈 on 2/15/26.
//

struct StoryInfo {
    let id: String
    let text: String // 대본
    let expression: CharacterExpression // Gosan 표정
    let nextStep: StoryStep? // 다음 화면
    let showPrevButton: Bool
    let showNextButton: Bool
    let prevButtonText: String
    let nextButtonText: String
    
    init(id: String,
         text: String,
         expression: CharacterExpression,
         nextStep: StoryStep?,
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

struct QuizInfo {
    let id: String
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
    let nextStep: StoryStep?
}

struct StoryData {
    static let messages: [StoryStep: StoryInfo] = [
        .intro(page: 1): StoryInfo(id: "intro_1",
                             text: """
        Hi, I'm Gosan ⛰️.
        |
        I'm a developer 
        from South Korea.
        |
        I love rare plants, bass guitar,
        and building apps that matter.
        """,
                             expression: .happy,
                                   nextStep: .intro(page: 2),
                             showPrevButton: false),
        .intro(page: 2): StoryInfo(id: "intro_2",
                                   text: """
            I also have mild hearing loss.
            |
            Most people don't notice.
            But I struggle every single day.
            """,
                                   expression: .empathetic,
                                   nextStep: .intro(page: 3)),
        .intro(page: 3): StoryInfo(id: "intro_3",
                                   text: """
            Let me show you what I hear.
            """,
                                   expression: .confused,
                                   nextStep: .scene(number: 1, phase: .dialogue(page: 1)),
                                  nextButtonText: "Experience My World"),
        // MARK: Scene 1: Coffee Shop
        .scene(number: 1, phase: .dialogue(page: 1)): StoryInfo(id: "s1_d1",
                                                                 text: """
                                                                This happened to me last Tuesday.
                                                                |
                                                                I ordered my usual latte.
                                                                Then waited for my number.
                                                                """,
                                                                 expression: .none,
                                                                 nextStep: .scene(number: 1,
                                                                                   phase: .tts)),
        .scene(number: 1, phase: .tts): StoryInfo(id: "s1_tts",
                                                  text: """
""",
                                                  expression: .none,
                                                  nextStep: .scene(number: 1,
                                                                   phase: .quiz(page: 1)),
                                                  showPrevButton: false,
                                                  showNextButton: false)
    ]
}
