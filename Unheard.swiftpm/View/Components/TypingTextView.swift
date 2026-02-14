//
//  TypingTextView.swift
//  Unheard
//
//  Created by 이치훈 on 2/12/26.
//

import SwiftUI

struct TypingTextView: View {
    var text: String
    let width: CGFloat
    let height: CGFloat
    let typingSpeed: UInt64
    let pauseDelay: UInt64
    let pauseMarker: String
    let onComplete: ((Bool) -> Void)?
    
    @State private var displayText: String = ""
    @State private var textProgress: Int = 0
    
    init(text: String,
         width: CGFloat,
         height: CGFloat,
         typingSpeed: UInt64 = 20_000_000,
         pauseDelay: UInt64 = 500_000_000,
         pauseMarker: String = "|",
         onComplete: ((Bool) -> Void)? = nil) {
        self.text = text
        self.width = width
        self.height = height
        self.typingSpeed = typingSpeed
        self.pauseDelay = pauseDelay
        self.pauseMarker = pauseMarker
        self.onComplete = onComplete
    }
    
    var body: some View {
        ZStack {
            // 투명한 전체 텍스트로 공간 확보
            Text(text.replacingOccurrences(of: pauseMarker, with: ""))
                .font(.title)
                .foregroundStyle(.clear)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            // 실제 표시되는 타이핑 텍스트
            VStack {
                Text(displayText)
                    .font(.title)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
        }
        .frame(width: width,
               height: height)
        .task {
            await typeText()
        }
    }
    
    private func typeText() async {
        for i in 0...text.count {
            try? await Task.sleep(nanoseconds: typingSpeed)
            
            textProgress = i
            
            let currentText = String(text.prefix(i))
            
            if i < text.count {
                let currentIdex = text.index(text.startIndex, offsetBy: i)
                let currentCharacter = String(text[currentIdex])
                
                if currentCharacter == pauseMarker {
                    try? await Task.sleep(nanoseconds: pauseDelay)
                }
            }
            
            displayText = currentText.replacingOccurrences(of: pauseMarker, with: "")
            
            if i == text.count {
                onComplete?(true)
            }
        }
    }
}

