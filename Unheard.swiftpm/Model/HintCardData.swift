//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/27/26.
//

import Foundation

struct HintCard {
    let emoji: String
    let title: String
    let descriptions: [String]
}

struct HintCardData {

    static let coffeShop = (
        title: "WAYS TO HELP: COFFEE SHOP",
        cards: [
            HintCard(emoji: "👀",
                     title: "FACE THEM",
                     descriptions: [
                        "Make eye contact.",
                        "Lip reading helps more than you think."
                     ]),
            HintCard(emoji: "👁️",
                     title: "USE VISUAL CUES",
                     descriptions: [
                        "Hold up the item.",
                        "Point or gesture.",
                        "A simple wave works wonders."
                     ])
            
        ]
    )
    
    static let subway = (
        title: "WAYS TO HELP: DESIGN FOR EVERYONE",
        cards: [
            HintCard(emoji: "👁️",
                     title: "SHOW, DON'T JUST SAY",
                     descriptions: [
                        "If it's important,",
                        "make it visible.",
                        "Text and visuals reach everyone."
                     ]),
            HintCard(emoji: "📝",
                     title: "CAPTION THE WORLD",
                     descriptions: [
                        "Real-time captions aren't just",
                        "for videos.",
                        "Any spoken info can be captioned."
                     ]),
            HintCard(emoji: "💡",
                     title: "USE EVERY SENSE",
                     descriptions: [
                        "Light. Vibration. Motion.",
                        "Good design speaks to all the senses",
                        "not just hearing."
                     ])
        ]
    )
    
    static let meeting = (
        title: "WAYS TO HELP: MEETINGS",
        cards: [
            HintCard(emoji: "🔄",
                     title: "REPHRASE, DON'T REPEAT",
                     descriptions: [
                        "If they didn't catch it,",
                        "try different words.",
                        "Some sounds are harder to hear."
                     ]),
            HintCard(emoji: "📋",
                     title: "FOLLOW UP IN WRITING",
                     descriptions: [
                        "Send a quick summary.",
                        "Share meeting notes.",
                        "It's helpful for everyone, actually."
                     ]),
            HintCard(emoji: "🤫",
                     title: "BE DISCREET",
                     descriptions: [
                        "Don't draw attention.",
                        "A private check-in means everything.",
                        "Respect goes a long way."
                     ])
        ]
    )
}

struct HintCardDataKR {
    
    static let coffeShop = (
        title: "도움 방법: 카페",
        cards: [
            HintCard(emoji: "👀",
                     title: "얼굴을 마주보세요",
                     descriptions: [
                        "눈을 맞춰주세요.",
                        "입술 읽기는 생각보다 큰 도움이 돼요."
                     ]),
            HintCard(emoji: "👁️",
                     title: "시각적 신호를 사용하세요",
                     descriptions: [
                        "음료를 들어 보여주세요.",
                        "손짓이나 제스처를 해주세요.",
                        "간단한 손 흔들기만으로도 충분해요."
                     ])
        ]
    )
    
    static let subway = (
        title: "도움 방법: 모두를 위한 디자인",
        cards: [
            HintCard(emoji: "👁️",
                     title: "말하지 말고 보여주세요",
                     descriptions: [
                        "중요한 정보라면",
                        "눈에 보이게 만들어주세요.",
                        "텍스트와 시각 정보는 모두에게 닿아요."
                     ]),
            HintCard(emoji: "📝",
                     title: "세상에 자막을 달아주세요",
                     descriptions: [
                        "실시간 자막은",
                        "영상에만 필요한 게 아니에요.",
                        "모든 음성 정보에 자막을 달 수 있어요."
                     ]),
            HintCard(emoji: "💡",
                     title: "모든 감각을 활용하세요",
                     descriptions: [
                        "빛. 진동. 움직임.",
                        "좋은 디자인은 모든 감각에 말을 걸어요.",
                        "청각에만 의존하지 않아요."
                     ])
        ]
    )
    
    static let meeting = (
        title: "도움 방법: 회의",
        cards: [
            HintCard(emoji: "🔄",
                     title: "반복 말고 바꿔서 말해주세요",
                     descriptions: [
                        "못 알아들었다면",
                        "다른 단어로 다시 말해주세요.",
                        "어떤 소리는 더 듣기 어려워요."
                     ]),
            HintCard(emoji: "📋",
                     title: "글로 정리해주세요",
                     descriptions: [
                        "간단한 요약을 보내주세요.",
                        "회의록을 공유해주세요.",
                        "사실 모두에게 도움이 돼요."
                     ]),
            HintCard(emoji: "🤫",
                     title: "조용히 확인해주세요",
                     descriptions: [
                        "주목받게 하지 마세요.",
                        "개인적으로 확인해주는 게 전부예요.",
                        "배려는 큰 힘이 돼요."
                     ])
        ]
    )
}
