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

struct StoryData {
    
    // MARK: - Message Data
    static let messages: [StoryStep: StoryInfo] = [
        // MARK: - Intro
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
            Most people don't notice.           But I struggle every single day.
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
                                                                     {c}Lucky guess.{/c}
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
                                                                     {c}You got it.{/c}
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
        .scene(number: 2, phase: .dialogue(page: 12)): StoryInfo(id: "tts_retry",
                                                                 text: """
                                                                     In real life,
                                                                     subway announcements don't repeat.
                                                                     |
                                                                     I just have to guess and hope.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .quiz(page: 1)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true), // s2_quiz 다시 듣기 시
        .scene(number: 2, phase: .dialogue(page: 2)): StoryInfo(id: "s2_ls",
                                                                text: """
                                                                    Fourteen, forty, forty-two...
                                                                    |
                                                                    They all blur together.
                                                                    """,
                                                                nextStep: .scene(number: 3, phase: .dialogue(page: 1)),
                                                                showPrevButton: true,
                                                                showNextButton: true),
        // MARK: - Scene 3: Office Meeting
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
                                                                     {c}Correct.{/c} But I wasn't sure.
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
                                                                nextStep: .intro(page: 4)),
        // MARK: - Perspective Shift
        .intro(page: 4): StoryInfo(id: "outro_1",
                                   text: """
                                       Now you've heard what I hear.
                                       """,
                                   expression: .empathetic,
                                   nextStep: .intro(page: 5)),
        .intro(page: 5): StoryInfo(id: "outro_2",
                                   text: """
                                       But here's the good news—
                                       You can make it easier.
                                       """,
                                   expression: .happy,
                                   nextStep: .intro(page: 6)),
        .intro(page: 6): StoryInfo(id: "outro_3",
                                   text: """
                                       For me.
                                       For the 466 million people like me.
                                       |
                                       Let me show you how.
                                       """,
                                   expression: .empathetic,
                                   nextStep: .scene(number: 1, phase: .dialogue(page: 3)),
                                   nextButtonText: "Continue"),
        // MARK: - BC 1
        .scene(number: 1, phase: .dialogue(page: 3)): StoryInfo(id: "bc1_d1",
                                                                text: """
                                                                    Now you're the barista.
                                                                    |
                                                                    A customer with hearing loss is waiting.
                                                                    Their order is ready.
                                                                    """,
                                                                nextStep: .scene(number: 1, phase: .dialogue(page: 4))),
        .scene(number: 1, phase: .dialogue(page: 4)): StoryInfo(id: "bc1_d2",
                                                                text: """
                                                                    How will you get their attention?
                                                                    """,
                                                                nextStep: .scene(number: 1, phase: .quiz(page: 2))),
        .scene(number: 1, phase: .dialogue(page: 20)): StoryInfo(id: "bc1_co1",
                                                                 text: """
                                                                     {c}Perfect.{/c}
                                                                     |
                                                                     When you face me, I can read your lips.
                                                                     I can see your expressions.
                                                                     It helps more than you think.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .dialogue(page: 3)),
                                                                 showPrevButton: false),
        .scene(number: 1, phase: .dialogue(page: 30)): StoryInfo(id: "bc1_co2",
                                                                 text: """
                                                                     {c}Great thinking!{/c}
                                                                     |
                                                                     Visual cues are incredibly helpful.
                                                                     A simple gesture can save me from
                                                                     an awkward moment.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .dialogue(page: 3)),
                                                                 showPrevButton: false),
        .scene(number: 1, phase: .dialogue(page: 21)): StoryInfo(id: "bc1_wr1",
                                                                 text: """
                                                                     OUCH.
                                                                     |
                                                                     Louder doesn't mean clearer.
                                                                     For me, loud sounds are painful—
                                                                     but still unclear.
                                                                     """,
                                                                 nextStep: .scene(number: 1, phase: .quiz(page: 2)),
                                                                 showPrevButton: false),
        .scene(number: 1, phase: .dialogue(page: 31)): StoryInfo(id: "bc1_wr2",
                                                                 text: """
                                                                     I might never notice.
                                                                     |
                                                                     And I'd go home wondering
                                                                     what happened to my order.
                                                                     |
                                                                     A small gesture goes a long way.
                                                                     """,
                                                                 nextStep: .scene(number: 1, phase: .quiz(page: 2)),
                                                                 showPrevButton: false),
        // MARK: - BC 2
        .scene(number: 2, phase: .dialogue(page: 3)): StoryInfo(id: "bc2_d1",
                                                                text: """
                                                                    You just rode the subway with Gosan.
                                                                    |
                                                                    Now you're in charge.
                                                                    You're redesigning this subway system.
                                                                    """,
                                                                nextStep: .scene(number: 2, phase: .dialogue(page: 4)),
                                                                showPrevButton: false),
        .scene(number: 2, phase: .dialogue(page: 4)): StoryInfo(id: "bc2_d2",
                                                                text: """
                                                                    Which feature would help
                                                                    passengers like me the most?
                                                                    |
                                                                    How would you help?
                                                                    """,
                                                                nextStep: .scene(number: 2, phase: .quiz(page: 2))),
        .scene(number: 2, phase: .dialogue(page: 20)): StoryInfo(id: "bc2_co1",
                                                                 text: """
                                                                     I don't have to hear it.
                                                                     I can just look up and know.
                                                                     |
                                                                     This is what {c}good design{/c} feels like.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .dialogue(page: 4)),
                                                                 showPrevButton: false),
        .scene(number: 2, phase: .dialogue(page: 30)): StoryInfo(id: "bc2_co2",
                                                                 text: """
                                                                     Now I can {c}read what I can't hear.{/c}
                                                                     Delays. Alerts. Everything.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .dialogue(page: 4)),
                                                                 showPrevButton: false),
        .scene(number: 2, phase: .dialogue(page: 40)): StoryInfo(id: "bc2_co3",
                                                                 text: """
                                                                     Not heard. Felt.
                                                                     A simple flash—I never miss the doors.
                                                                     |
                                                                     Design {c}doesn't always need sound.{/c}
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .dialogue(page: 4)),
                                                                 showPrevButton: false),
        .scene(number: 2, phase: .dialogue(page: 21)): StoryInfo(id: "bc2_wr1",
                                                                 text: """
                                                                     Louder doesn't mean clearer.
                                                                     Volume was never the problem.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .quiz(page: 2)),
                                                                 showPrevButton: false),
        // MARK: - BC 3
        .scene(number: 3, phase: .dialogue(page: 4)): StoryInfo(id: "bc3_d1",
                                                                text: """
                                                                    You're in a team meeting.
                                                                    Your colleague with hearing loss looks lost.
                                                                    |
                                                                    The meeting just ended.
                                                                    What will you do?
                                                                    """,
                                                                nextStep: .scene(number: 3, phase: .quiz(page: 2))),
        .scene(number: 3, phase: .dialogue(page: 20)): StoryInfo(id: "bc3_co1",
                                                                 text: """
                                                                     This helps {c}more than you know.{/c}
                                                                     I can review what I missed—without asking.
                                                                     """,
                                                                 nextStep: .intro(page: 7),
                                                                 showPrevButton: false),
        .scene(number: 3, phase: .dialogue(page: 30)): StoryInfo(id: "bc3_co2",
                                                                 text: """
                                                                     {c}Perfect.{/c}
                                                                     |
                                                                     I can read it at my own pace.
                                                                     You just made my day easier.
                                                                     """,
                                                                 nextStep: .intro(page: 7),
                                                                 showPrevButton: false),
        .scene(number: 3, phase: .dialogue(page: 21)): StoryInfo(id: "bc3_wr1",
                                                                 text: """
                                                                     I probably didn't understand.
                                                                     But I won't ask—I don't want to seem incompetent.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .quiz(page: 2)),
                                                                 showPrevButton: false),
        .scene(number: 3, phase: .dialogue(page: 31)): StoryInfo(id: "bc3_wr2",
                                                                 text: """
                                                                     Now everyone's staring at me.
                                                                     A private message would've been better.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .quiz(page: 2)),
                                                                 showPrevButton: false),
        // MARK: - Outro
        .intro(page: 7): StoryInfo(id: "outro_1",
                                   text: """
                                       466 million people have hearing loss.
                                       |
                                       You probably know someone.
                                       Maybe you didn't realize.
                                       """,
                                   expression: .empathetic,
                                   nextStep: .outro(page: 1),
                                   showPrevButton: false),
        .outro(page: 1): StoryInfo(id: "outro_2",
                                   text: """
                                       A little patience changes everything.
                                       |
                                       Thank you for listening.
                                       |
                                       — Gosan
                                       """,
                                   expression: .empathetic)
    ]
    
    // MARK: - Quiz Data
    static let quizzes: [StoryStep: QuizInfo] = [
        .scene(number: 1, phase: .quiz(page: 1)): QuizInfo(id: "s1_q1",
                                                           question: "What was the order number?",
                                                           options: [
                                                            "50", "55", "15", "51"
                                                           ],
                                                           correctIndices: [2],
                                                           correctSteps: [ 2: .scene(number: 1, phase: .dialogue(page: 10))
                                                                         ],
                                                           wrongSteps: [:],
                                                           defaultWrongStep: .scene(number: 1, phase: .dialogue(page: 11)),
                                                           hint: nil,
                                                           quizType: .grid,
                                                           hintCards: nil),
        .scene(number: 2, phase: .quiz(page: 1)): QuizInfo(id: "s2_q1",
                                                           question: "Which station was that?",
                                                           options: [
                                                            "14th Street",
                                                            "34th Street",
                                                            "42nd Street",
                                                            "52nd Street"
                                                           ],
                                                           correctIndices: [2],
                                                           correctSteps: [
                                                            2: .scene(number: 2, phase: .dialogue(page: 10))
                                                           ],
                                                           wrongSteps: [:],
                                                           defaultWrongStep: .scene(number: 2, phase: .dialogue(page: 11)),
                                                           hint: nil,
                                                           quizType: .grid,
                                                           hintCards: nil),
        .scene(number: 3, phase: .quiz(page: 1)): QuizInfo(id: "s3_q1",
                                                           question: "What task were you assigned?",
                                                           options: [
                                                            "Client presentation",
                                                            "Dashboard issue",
                                                            "Weekly report",
                                                            "I couldn't tell"
                                                           ],
                                                           correctIndices: [1],
                                                           correctSteps: [ 1: .scene(number: 3, phase: .dialogue(page: 10))
                                                                         ],
                                                           wrongSteps: [:],
                                                           defaultWrongStep: .scene(number: 3, phase: .dialogue(page: 11)),
                                                           hint: nil,
                                                           quizType: .stack,
                                                           hintCards: nil),
        // MARK: - BC Quiz
        .scene(number: 1, phase: .quiz(page: 2)): QuizInfo(id: "bc1_q2",
                                                           question: "How would you help?", options: [
                                                            "Shout louder",
                                                            "Walk up and wave",
                                                            "Hold up the cup",
                                                            "Just wait"
                                                           ], correctIndices: [1, 2], correctSteps: [
                                                            1: .scene(number: 1, phase: .dialogue(page: 20)),
                                                            2: .scene(number: 1, phase: .dialogue(page: 30))
                                                           ],
                                                           wrongSteps:[
                                                            0: .scene(number: 1, phase: .dialogue(page: 21)),
                                                            3: .scene(number: 1, phase: .dialogue(page: 31))
                                                           ],
                                                           defaultWrongStep: .scene(number: 1, phase: .dialogue(page: 4)),
                                                           hint: nil,
                                                           quizType: .stack,
                                                           hintCards: HintCardData.coffeShop),
        .scene(number: 2, phase: .quiz(page: 2)): QuizInfo(id: "bc2_q2",
                                                           question: "How would you help?",
                                                           options: [
                                                            "Make the announcements louder",
                                                            "Display station name on screens",
                                                            "Add real-time captions",
                                                            "Flash lights when doors close"
                                                           ],
                                                           correctIndices: [1, 2, 3],
                                                           correctSteps: [
                                                            1: .scene(number: 2, phase: .dialogue(page: 20)),
                                                            2: .scene(number: 2, phase: .dialogue(page: 30)),
                                                            3: .scene(number: 2, phase: .dialogue(page: 40))
                                                           ],
                                                           wrongSteps: [:],
                                                           defaultWrongStep: .scene(number: 2, phase: .dialogue(page: 21)),
                                                           hint: nil,
                                                           quizType: .stack,
                                                           hintCards: HintCardData.subway),
        .scene(number: 3, phase: .quiz(page: 2)): QuizInfo(id: "bc3_q2",
                                                           question: "What will you do?",
                                                           options: [
                                                            "Assume they understood",
                                                            "Share your notes",
                                                            "Repeat loudly",
                                                            "Summarize in a message"
                                                           ],
                                                           correctIndices: [1, 3],
                                                           correctSteps: [
                                                            1: .scene(number: 3, phase: .dialogue(page: 20)),
                                                            3: .scene(number: 3, phase: .dialogue(page: 30))
                                                           ],
                                                           wrongSteps: [
                                                            0: .scene(number: 3, phase: .dialogue(page: 21)),
                                                            2: .scene(number: 3, phase: .dialogue(page: 31))
                                                           ],
                                                           defaultWrongStep: .scene(number: 3, phase: .dialogue(page: 21)),
                                                           hint: nil,
                                                           quizType: .stack,
                                                           hintCards: HintCardData.meeting)
    ]
}
