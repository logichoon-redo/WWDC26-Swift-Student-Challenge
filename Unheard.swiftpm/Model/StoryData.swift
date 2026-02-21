//
//  StoryData.swift
//  Unheard
//
//  Created by 이치훈 on 2/15/26.
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
    let correctIndex: Int
    let correctStep: StoryStep
    let wrongStep: StoryStep
    let hint: String?
    let quizType: QuizType
}

struct StoryData {
    
    // MARK: - Message Data
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
        // MARK: - Scene 1: Coffee Shop
        .scene(number: 1, phase: .dialogue(page: 1)): StoryInfo(id: "s1_d1",
                                                                text: """
                                                                This happened to me last Tuesday.
                                                                |
                                                                I ordered my usual latte.
                                                                Then waited for my number.
                                                                """,
                                                                expression: .none,
                                                                nextStep: .scene(number: 1,
                                                                                 phase: .tts),
                                                                nextButtonText: "Listen"),
        .scene(number: 1, phase: .tts): StoryInfo(id: "s1_tts",
                                                  text: """
I have a grande latte for order 15!
""",
                                                  expression: .none,
                                                  nextStep: .scene(number: 1,
                                                                   phase: .quiz(page: 1)),
                                                  showPrevButton: false,
                                                  showNextButton: false),
        .scene(number: 1, phase: .dialogue(page: 10)): StoryInfo(id: "s1_correct",
                                                                 text: """
                                                                     Lucky guess.
                                                                     |
                                                                     But honestly?
                                                                     |
                                                                     I wasn't sure either.
                                                                     """,
                                                                 expression: .none,
                                                                 nextStep: .scene(number: 1, phase: .dialogue(page: 2)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true), // quiz 1 정답
        .scene(number: 1, phase: .dialogue(page: 11)): StoryInfo(id: "s1_wrong",
                                                                 text: """
                                                                     That's what I heard too.
                                                                     |
                                                                     I waited and waited...
                                                                     |
                                                                     Someone else took my latte.
                                                                     """, nextStep: .scene(number: 1, phase: .quiz(page: 1)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true), // quiz 1 오답
        .scene(number: 1, phase: .dialogue(page: 2)): StoryInfo(id: "s1_ls",
                                                                text:"""
                                                                    Fifty and fifteen sound almost the same to me.
                                                                    """,
                                                                nextStep: .scene(number: 2, phase: .dialogue(page: 1)),
                                                                showPrevButton: true,
                                                                showNextButton: true),
        // MARK: - Scene 2: Subway
        .scene(number: 2, phase: .dialogue(page: 1)): StoryInfo(id: "s2_d1",
                                                                text: """
                                                                    Subway announcements are my nightmare.
                                                                    |
                                                                    I was heading to Penn Station.
                                                                    The announcement played...
                                                                    """,
                                                                nextStep: .scene(number: 2, phase: .tts),
                                                                showPrevButton: false,
                                                                showNextButton: true,
                                                                nextButtonText: "Listen"),
        .scene(number: 2, phase: .tts): StoryInfo(id: "s2_tts",
                                                  text: "This is 42nd Street.   Transfer is available to the 1, 2, 3 and 7 trains.",
                                                  nextStep: .scene(number: 2, phase: .quiz(page: 1))),
        .scene(number: 2, phase: .dialogue(page: 10)): StoryInfo(id: "s2_correct",
                                                                 text: """
                                                                     You got it.
                                                                     But I usually can't.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .dialogue(page: 2)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true), // s2 정답
        .scene(number: 2, phase: .dialogue(page: 11)): StoryInfo(id: "s2_wrong",
                                                                 text: """
                                                                     I got off at the wrong station.
                                                                     I was late for my interview.
                                                                     |
                                                                     This has happened more than once.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .quiz(page: 1)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true), // s2 오답
        .scene(number: 2, phase: .dialogue(page: 2)): StoryInfo(id: "s2_ls",
                                                                text: """
                                                                    Fourteen, forty, forty-two...
                                                                    |
                                                                    They all blur together.
                                                                    """,
                                                                nextStep: .scene(number: 3, phase: .dialogue(page: 1)),
                                                                showPrevButton: true,
                                                                showNextButton: true),
        // MARK: Scene 3: Office Meeting
        .scene(number: 3, phase: .dialogue(page: 1)): StoryInfo(id: "s3_d1",
                                                                text: """
                                                                    But the hardest part?
                                                                    Team meetings.
                                                                    """,
                                                                nextStep: .scene(number: 3, phase: .dialogue(page: 2)),
                                                                showPrevButton: false,
                                                                showNextButton: true),
        .scene(number: 3, phase: .dialogue(page: 2)): StoryInfo(id: "s3_d2",
                                                                text: """
                                                                    Everyone talks fast.
                                                                    |
                                                                    Multiple voices overlap.
                                                                    And I'm supposed to keep up.
                                                                    """,
                                                                nextStep: .scene(number: 3, phase: .tts),
                                                                nextButtonText: "Listen",
                                                               ),
        .scene(number: 3, phase: .tts): StoryInfo(id: "s3_tts",
                                                  text: "Alright team, let's go over this week's tasks. Gosan, can you fix the dashboard issue before the demo on Friday?",
                                                  nextStep: .scene(number: 3, phase: .quiz(page: 1))),
        .scene(number: 3, phase: .dialogue(page: 10)): StoryInfo(id: "s3_correct",
                                                                 text: """
                                                                     Correct. But I wasn't sure.
                                                                     I nodded anyway.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .dialogue(page: 3)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true), // s3 정답
        .scene(number: 3, phase: .dialogue(page: 11)): StoryInfo(id: "s3_wrong",
                                                                 text: """
                                                                     That's what I would have guessed too.
                                                                     I usually ask a coworker later.
                                                                     Pretending I understood.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .quiz(page: 1)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true),
        .scene(number: 3, phase: .dialogue(page: 3)): StoryInfo(id: "s3_ls",
                                                                text: """
                                                                    The worst part isn't mishearing.
                                                                    |
                                                                    It's pretending I didn't.
                                                                    """,
                                                                nextStep: .outro(page: 1))
        
    ]
    
    // MARK: - Quiz Data
    static let quizzes: [StoryStep: QuizInfo] = [
        .scene(number: 1, phase: .quiz(page: 1)): QuizInfo(id: "s1_q1",
                                                           question: "What was the order number?",
                                                           options: ["50", "55", "15", "51"],
                                                           correctIndex: 2,
                                                           correctStep: .scene(number: 1, phase: .dialogue(page: 10)),
                                                           wrongStep: .scene(number: 1, phase: .dialogue(page: 11)),
                                                           hint: "Your Number is 50",
                                                           quizType: .grid),
        .scene(number: 2, phase: .quiz(page: 1)): QuizInfo(id: "s2_q1",
                                                           question: "Which station was that?",
                                                           options: ["14th Street", "34th Street", "42nd Street", "52nd Street"],
                                                           correctIndex: 2,
                                                           correctStep: .scene(number: 2, phase: .dialogue(page: 10)),
                                                           wrongStep: .scene(number: 2, phase: .dialogue(page: 11)),
                                                           hint: nil,
                                                           quizType: .grid),
        .scene(number: 3, phase: .quiz(page: 1)): QuizInfo(id: "s3_q1",
                                                           question: "What task were you assigned?",
                                                           options: ["Client presentation", "Dashboard issue", "Weekly report", "I couldn't tell"],
                                                           correctIndex: 1,
                                                           correctStep: .scene(number: 3, phase: .dialogue(page: 10)),
                                                           wrongStep: .scene(number: 3, phase: .dialogue(page: 11)),
                                                           hint: nil,
                                                           quizType: .stack)
    ]
}
