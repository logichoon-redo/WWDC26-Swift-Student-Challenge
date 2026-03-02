//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 3/2/26.
//

import Foundation

struct StoryDataKR {
    
    // MARK: - Message Data
    static let messages: [StoryStep: StoryInfo] = [
        // MARK: - Intro
        .intro(page: 1): StoryInfo(id: "intro_1",
                                   text: """
        안녕하세요, 고산이에요 ⛰️.
        |
        저는 한국에서 온 개발자예요.
        |
        희귀식물, 베이스 기타,
        그리고 의미있는 앱 개발을 좋아해요.
        """,
                                   expression: .happy,
                                   nextStep: .intro(page: 2),
                                   showPrevButton: false),
        .intro(page: 2): StoryInfo(id: "intro_2",
                                   text: """
                                       저는 약간의 난청이 있어요.
                                       |
                                       대부분의 사람들은 모르죠.
                                       하지만 저는 매일 힘들어요.
                                       """,
                                   expression: .empathetic,
                                   nextStep: .intro(page: 3)),
        .intro(page: 3): StoryInfo(id: "intro_3",
                                   text: """
            제가 듣는 세상을 보여드릴게요.
            """,
                                   expression: .confused,
                                   nextStep: .scene(number: 1, phase: .dialogue(page: 1)),
                                   nextButtonText: "체험하기"),
        // MARK: - Scene 1: 카페
        .scene(number: 1, phase: .dialogue(page: 1)): StoryInfo(id: "s1_d1",
                                                                text: """
                                                                지난 화요일에 있었던 일이에요.
                                                                |
                                                                늘 먹던 아이스 아메리카노를 주문하고
                                                                번호를 기다렸어요.
                                                                """,
                                                                expression: .none,
                                                                nextStep: .scene(number: 1,
                                                                                 phase: .tts),
                                                                nextButtonText: "들어보기"),
        .scene(number: 1, phase: .tts): StoryInfo(id: "s1_tts",
                                                  text: """
15번 손님, 아이스 아메리카노 나왔습니다!
""",
                                                  expression: .none,
                                                  nextStep: .scene(number: 1,
                                                                   phase: .quiz(page: 1)),
                                                  showPrevButton: false,
                                                  showNextButton: false),
        .scene(number: 1, phase: .dialogue(page: 10)): StoryInfo(id: "s1_correct",
                                                                 text: """
                                                                     {c}운 좋게 맞췄네요.{/c}
                                                                     |
                                                                     솔직히 말해서
                                                                     |
                                                                     저도 확신이 없었어요.
                                                                     """,
                                                                 expression: .none,
                                                                 nextStep: .scene(number: 1, phase: .dialogue(page: 2)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true),
        .scene(number: 1, phase: .dialogue(page: 11)): StoryInfo(id: "s1_wrong",
                                                                 text: """
                                                                     저도 그렇게 들렸어요.
                                                                     |
                                                                     한참을 기다렸는데...
                                                                     |
                                                                     다른 사람이 제 커피를 가져갔어요.
                                                                     """, nextStep: .scene(number: 1, phase: .quiz(page: 1)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true),
        .scene(number: 1, phase: .dialogue(page: 2)): StoryInfo(id: "s1_ls",
                                                                text: """
                                                                    50번과 15번은 저한테 거의 똑같이 들려요.
                                                                    """,
                                                                nextStep: .scene(number: 2, phase: .dialogue(page: 1)),
                                                                showPrevButton: true,
                                                                showNextButton: true),
        // MARK: - Scene 2: 지하철
        .scene(number: 2, phase: .dialogue(page: 1)): StoryInfo(id: "s2_d1",
                                                                text: """
                                                                    지하철 안내방송은 저한테 악몽이에요.
                                                                    |
                                                                    강남역에 가는 중이었어요.
                                                                    안내방송이 나왔는데...
                                                                    """,
                                                                nextStep: .scene(number: 2, phase: .tts),
                                                                showPrevButton: false,
                                                                showNextButton: true,
                                                                nextButtonText: "들어보기"),
        .scene(number: 2, phase: .tts): StoryInfo(id: "s2_tts",
                                                  text: "이번 역은 신촌, 신촌역입니다. 2호선과 경의중앙선으로 환승하실 수 있습니다.",
                                                  nextStep: .scene(number: 2, phase: .quiz(page: 1))),
        .scene(number: 2, phase: .dialogue(page: 10)): StoryInfo(id: "s2_correct",
                                                                 text: """
                                                                     {c}맞췄네요.{/c}
                                                                     하지만 저는 보통 못 알아들어요.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .dialogue(page: 2)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true),
        .scene(number: 2, phase: .dialogue(page: 11)): StoryInfo(id: "s2_wrong",
                                                                 text: """
                                                                     엉뚱한 역에서 내렸어요.
                                                                     면접에 늦었죠.
                                                                     |
                                                                     이런 일이 한두 번이 아니에요.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .quiz(page: 1)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true),
        .scene(number: 2, phase: .dialogue(page: 12)): StoryInfo(id: "tts_retry",
                                                                 text: """
                                                                     현실에서는
                                                                     지하철 안내방송이 다시 나오지 않아요.
                                                                     |
                                                                     그냥 찍고 기도하는 수밖에 없죠.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .quiz(page: 1)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true),
        .scene(number: 2, phase: .dialogue(page: 2)): StoryInfo(id: "s2_ls",
                                                                text: """
                                                                    신천, 신당, 신촌, 신림...
                                                                    |
                                                                    다 비슷하게 들려요.
                                                                    """,
                                                                nextStep: .scene(number: 3, phase: .dialogue(page: 1)),
                                                                showPrevButton: true,
                                                                showNextButton: true),
        // MARK: - Scene 3: 회의실
        .scene(number: 3, phase: .dialogue(page: 1)): StoryInfo(id: "s3_d1",
                                                                text: """
                                                                    근데 가장 힘든 건요?
                                                                    팀 회의예요.
                                                                    """,
                                                                nextStep: .scene(number: 3, phase: .dialogue(page: 2)),
                                                                showPrevButton: false,
                                                                showNextButton: true),
        .scene(number: 3, phase: .dialogue(page: 2)): StoryInfo(id: "s3_d2",
                                                                text: """
                                                                    다들 빠르게 말하고,
                                                                    |
                                                                    여러 목소리가 겹쳐요.
                                                                    그 와중에 따라가야 하죠.
                                                                    """,
                                                                nextStep: .scene(number: 3, phase: .tts),
                                                                nextButtonText: "들어보기"),
        .scene(number: 3, phase: .tts): StoryInfo(id: "s3_tts",
                                                  text: "자, 이번 주 업무 정리합시다. 고산 씨, 금요일 데모 전까지 대시보드 이슈 수정 부탁합니다.",
                                                  nextStep: .scene(number: 3, phase: .quiz(page: 1))),
        .scene(number: 3, phase: .dialogue(page: 10)): StoryInfo(id: "s3_correct",
                                                                 text: """
                                                                     {c}맞아요.{/c} 하지만 확신은 없었어요.
                                                                     그냥 고개를 끄덕였죠.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .dialogue(page: 3)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true),
        .scene(number: 3, phase: .dialogue(page: 11)): StoryInfo(id: "s3_wrong",
                                                                 text: """
                                                                     저도 그렇게 들었을 거예요.
                                                                     보통 나중에 동료한테 슬쩍 물어봐요.
                                                                     알아들은 척하면서요.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .quiz(page: 1)),
                                                                 showPrevButton: false,
                                                                 showNextButton: true),
        .scene(number: 3, phase: .dialogue(page: 3)): StoryInfo(id: "s3_ls",
                                                                text: """
                                                                    가장 힘든 건 못 알아듣는 게 아니에요.
                                                                    |
                                                                    알아들은 척하는 거예요.
                                                                    """,
                                                                nextStep: .intro(page: 4)),
        // MARK: - Perspective Shift
        .intro(page: 4): StoryInfo(id: "outro_1",
                                   text: """
                                       이제 제가 듣는 세상을 경험하셨어요.
                                       """,
                                   expression: .empathetic,
                                   nextStep: .intro(page: 5)),
        .intro(page: 5): StoryInfo(id: "outro_2",
                                   text: """
                                       하지만 좋은 소식이 있어요—
                                       당신이 도울 수 있어요.
                                       """,
                                   expression: .happy,
                                   nextStep: .intro(page: 6)),
        .intro(page: 6): StoryInfo(id: "outro_3",
                                   text: """
                                       저를 위해서.
                                       저와 같은 4억 6,600만 명을 위해서.
                                       |
                                       어떻게 하는지 알려드릴게요.
                                       """,
                                   expression: .empathetic,
                                   nextStep: .scene(number: 1, phase: .dialogue(page: 3)),
                                   nextButtonText: "계속하기"),
        // MARK: - BC 1: 카페
        .scene(number: 1, phase: .dialogue(page: 3)): StoryInfo(id: "bc1_d1",
                                                                text: """
                                                                    이제 당신이 바리스타예요.
                                                                    |
                                                                    난청이 있는 손님이 기다리고 있어요.
                                                                    주문이 준비됐어요.
                                                                    """,
                                                                nextStep: .scene(number: 1, phase: .dialogue(page: 4))),
        .scene(number: 1, phase: .dialogue(page: 4)): StoryInfo(id: "bc1_d2",
                                                                text: """
                                                                    어떻게 알려줄 건가요?
                                                                    """,
                                                                nextStep: .scene(number: 1, phase: .quiz(page: 2))),
        .scene(number: 1, phase: .dialogue(page: 20)): StoryInfo(id: "bc1_co1",
                                                                 text: """
                                                                     {c}완벽해요.{/c}
                                                                     |
                                                                     얼굴을 보면 입술을 읽을 수 있어요.
                                                                     표정도 볼 수 있고요.
                                                                     생각보다 훨씬 큰 도움이 돼요.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .dialogue(page: 3)),
                                                                 showPrevButton: false),
        .scene(number: 1, phase: .dialogue(page: 30)): StoryInfo(id: "bc1_co2",
                                                                 text: """
                                                                     {c}좋은 생각이에요!{/c}
                                                                     |
                                                                     시각적 신호는 정말 큰 도움이 돼요.
                                                                     간단한 제스처 하나가
                                                                     어색한 순간을 막아줄 수 있어요.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .dialogue(page: 3)),
                                                                 showPrevButton: false),
        .scene(number: 1, phase: .dialogue(page: 21)): StoryInfo(id: "bc1_wr1",
                                                                 text: """
                                                                     아야.
                                                                     |
                                                                     크게 말한다고 선명해지는 게 아니에요.
                                                                     큰 소리는 아프기만 하고—
                                                                     여전히 안 들려요.
                                                                     """,
                                                                 nextStep: .scene(number: 1, phase: .quiz(page: 2)),
                                                                 showPrevButton: false),
        .scene(number: 1, phase: .dialogue(page: 31)): StoryInfo(id: "bc1_wr2",
                                                                 text: """
                                                                     아마 영원히 모를 거예요.
                                                                     |
                                                                     제 주문이 어떻게 됐는지 궁금해하며
                                                                     집에 갈 거예요.
                                                                     |
                                                                     작은 제스처가 큰 차이를 만들어요.
                                                                     """,
                                                                 nextStep: .scene(number: 1, phase: .quiz(page: 2)),
                                                                 showPrevButton: false),
        // MARK: - BC 2: 지하철
        .scene(number: 2, phase: .dialogue(page: 3)): StoryInfo(id: "bc2_d1",
                                                                text: """
                                                                    방금 고산이 지하철을 탔어요.
                                                                    |
                                                                    이제 당신이 시스템 담당자예요.
                                                                    이 지하철 시스템을 새로 설계해보세요.
                                                                    """,
                                                                nextStep: .scene(number: 2, phase: .dialogue(page: 4)),
                                                                showPrevButton: false),
        .scene(number: 2, phase: .dialogue(page: 4)): StoryInfo(id: "bc2_d2",
                                                                text: """
                                                                    저 같은 승객에게
                                                                    가장 도움이 되는 기능은 뭘까요?
                                                                    |
                                                                    혹은 어떻게 도울 건가요?
                                                                    """,
                                                                nextStep: .scene(number: 2, phase: .quiz(page: 2))),
        .scene(number: 2, phase: .dialogue(page: 20)): StoryInfo(id: "bc2_co1",
                                                                 text: """
                                                                     들을 필요가 없어요.
                                                                     올려다보면 바로 알 수 있으니까요.
                                                                     |
                                                                     이게 {c}좋은 디자인{/c}이에요.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .dialogue(page: 4)),
                                                                 showPrevButton: false),
        .scene(number: 2, phase: .dialogue(page: 30)): StoryInfo(id: "bc2_co2",
                                                                 text: """
                                                                     이제 {c}못 듣는 걸 읽을 수 있어요.{/c}
                                                                     지연, 알림, 전부 다요.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .dialogue(page: 4)),
                                                                 showPrevButton: false),
        .scene(number: 2, phase: .dialogue(page: 40)): StoryInfo(id: "bc2_co3",
                                                                 text: """
                                                                     듣는 게 아니라 느끼는 거예요.
                                                                     간단한 깜빡임—문 닫힘을 놓치지 않아요.
                                                                     |
                                                                     디자인에 {c}항상 소리가 필요한 건 아니에요.{/c}
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .dialogue(page: 4)),
                                                                 showPrevButton: false),
        .scene(number: 2, phase: .dialogue(page: 21)): StoryInfo(id: "bc2_wr1",
                                                                 text: """
                                                                     크게 한다고 선명해지는 게 아니에요.
                                                                     소리 크기가 문제가 아니었어요.
                                                                     """,
                                                                 nextStep: .scene(number: 2, phase: .quiz(page: 2)),
                                                                 showPrevButton: false),
        // MARK: - BC 3: 회의
        .scene(number: 3, phase: .dialogue(page: 4)): StoryInfo(id: "bc3_d1",
                                                                text: """
                                                                    팀 회의 중이에요.
                                                                    난청이 있는 동료가 헤매는 것 같아요.
                                                                    |
                                                                    회의가 막 끝났어요.
                                                                    어떻게 할 건가요?
                                                                    """,
                                                                nextStep: .scene(number: 3, phase: .quiz(page: 2))),
        .scene(number: 3, phase: .dialogue(page: 20)): StoryInfo(id: "bc3_co1",
                                                                 text: """
                                                                     이건 {c}생각보다 훨씬 큰 도움{/c}이에요.
                                                                     물어보지 않아도 놓친 걸 확인할 수 있으니까요.
                                                                     """,
                                                                 nextStep: .intro(page: 7),
                                                                 showPrevButton: false),
        .scene(number: 3, phase: .dialogue(page: 30)): StoryInfo(id: "bc3_co2",
                                                                 text: """
                                                                     {c}완벽해요.{/c}
                                                                     |
                                                                     제 속도로 읽을 수 있어요.
                                                                     당신 덕분에 하루가 편해졌어요.
                                                                     """,
                                                                 nextStep: .intro(page: 7),
                                                                 showPrevButton: false),
        .scene(number: 3, phase: .dialogue(page: 21)): StoryInfo(id: "bc3_wr1",
                                                                 text: """
                                                                     아마 못 알아들었을 거예요.
                                                                     하지만 물어보지 않아요—무능해 보이고 싶지 않으니까요.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .quiz(page: 2)),
                                                                 showPrevButton: false),
        .scene(number: 3, phase: .dialogue(page: 31)): StoryInfo(id: "bc3_wr2",
                                                                 text: """
                                                                     이제 다들 저를 쳐다봐요.
                                                                     개인 메시지가 더 나았을 텐데.
                                                                     """,
                                                                 nextStep: .scene(number: 3, phase: .quiz(page: 2)),
                                                                 showPrevButton: false),
        // MARK: - Outro
        .intro(page: 7): StoryInfo(id: "outro_1",
                                   text: """
                                       전 세계 4억 6,600만 명이 난청이 있어요.
                                       |
                                       아마 당신도 누군가를 알고 있을 거예요.
                                       몰랐을 뿐이죠.
                                       """,
                                   expression: .empathetic,
                                   nextStep: .outro(page: 1),
                                   showPrevButton: false),
        .outro(page: 1): StoryInfo(id: "outro_2",
                                   text: """
                                       작은 배려가 모든 걸 바꿔요.
                                       |
                                       들어주셔서 감사합니다.
                                       |
                                       — 고산 —
                                       """,
                                   expression: .empathetic)
    ]
    
    // MARK: - Quiz Data
    static let quizzes: [StoryStep: QuizInfo] = [
        .scene(number: 1, phase: .quiz(page: 1)): QuizInfo(id: "s1_q1",
                                                           question: "주문 번호가 몇 번이었나요?",
                                                           options: [
                                                            "50번", "55번", "15번", "51번"
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
                                                           question: "어떤 역이었나요?",
                                                           options: [
                                                            "신천역",
                                                            "신당역",
                                                            "신촌역",
                                                            "신림역"
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
                                                           question: "어떤 업무를 맡았나요?",
                                                           options: [
                                                            "클라이언트 발표",
                                                            "대시보드 이슈",
                                                            "주간 보고서",
                                                            "잘 못 들었음"
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
                                                           question: "어떻게 알려줄 건가요?",
                                                           options: [
                                                            "더 크게 외친다",
                                                            "다가가서 손을 흔든다",
                                                            "컵을 들어 보여준다",
                                                            "그냥 기다린다"
                                                           ],
                                                           correctIndices: [1, 2],
                                                           correctSteps: [
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
                                                           hintCards: HintCardDataKR.coffeShop),
        .scene(number: 2, phase: .quiz(page: 2)): QuizInfo(id: "bc2_q2",
                                                           question: "어떻게 도울 건가요?",
                                                           options: [
                                                            "안내방송을 더 크게 한다",
                                                            "화면에 역 이름을 표시한다",
                                                            "실시간 자막을 추가한다",
                                                            "문 닫힘 시 조명을 깜빡인다"
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
                                                           hintCards: HintCardDataKR.subway),
        .scene(number: 3, phase: .quiz(page: 2)): QuizInfo(id: "bc3_q2",
                                                           question: "어떻게 할 건가요?",
                                                           options: [
                                                            "알아들었겠거니 넘긴다",
                                                            "내 메모를 공유한다",
                                                            "크게 다시 말한다",
                                                            "메시지로 요약해준다"
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
                                                           hintCards: HintCardDataKR.meeting)
    ]
}
