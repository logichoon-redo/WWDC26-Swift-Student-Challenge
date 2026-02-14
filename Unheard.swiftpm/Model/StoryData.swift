//
//  StoryData.swift
//  Unheard
//
//  Created by 이치훈 on 2/15/26.
//


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
                                   nextStep: nil,
                                  nextButtonText: "Experience My World")
    ]
}
