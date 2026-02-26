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
