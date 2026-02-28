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
    let alignment: TextAlignment
    let highlightColor: Color
    let baseTextColor: Color
    let onComplete: ((Bool) -> Void)?
    
    @State private var displayText: String = ""
    @State private var textProgress: Int = 0
    
    init(text: String,
         width: CGFloat,
         height: CGFloat,
         typingSpeed: UInt64 = 20_000_000,
         pauseDelay: UInt64 = 300_000_000,
         pauseMarker: String = "|",
         alignment: TextAlignment = .center,
         baseTextColor: Color = .white,
         highlightColor: Color = .yellow,
         
         onComplete: ((Bool) -> Void)? = nil) {
        self.text = text
        self.width = width
        self.height = height
        self.typingSpeed = typingSpeed
        self.pauseDelay = pauseDelay
        self.pauseMarker = pauseMarker
        self.alignment = alignment
        self.highlightColor = highlightColor
        self.baseTextColor = baseTextColor
        self.onComplete = onComplete
    }
    
    private var horizontalAlignment: HorizontalAlignment {
        switch alignment {
        case .leading: .leading
        case .center: .center
        case .trailing: .trailing
        }
    }
    
    private var cleanText: String {
        text.replacingOccurrences(of: pauseMarker, with: "")
            .replacingOccurrences(of: "{c}", with: "")
            .replacingOccurrences(of: "{/c}", with: "")
    }
    
    private var styledDisplayText: AttributedString {
        var raw = displayText
        var result = AttributedString()
        
        while let openRange = raw.range(of: "{c}") {
            // 태그 앞 일반 텍스트
            let before = String(raw[raw.startIndex..<openRange.lowerBound])
            if !before.isEmpty {
                var attr = AttributedString(before)
                attr.foregroundColor = baseTextColor
                result += attr
            }
            
            raw = String(raw[openRange.upperBound...])
            
            if let closeRange = raw.range(of: "{/c}") {
                let highlighted = String(raw[raw.startIndex..<closeRange.lowerBound])
                var attr = AttributedString(highlighted)
                attr.foregroundColor = highlightColor
                result += attr
                raw = String(raw[closeRange.upperBound...])
            } else {
                // ✅ 타이핑 중 닫는 태그가 아직 안 나왔을 때
                var attr = AttributedString(raw)
                attr.foregroundColor = highlightColor
                result += attr
                raw = ""
            }
        }
        
        if !raw.isEmpty {
            var attr = AttributedString(raw)
            attr.foregroundColor = baseTextColor
            result += attr
        }
        
        return result
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: horizontalAlignment, vertical: .top)) {
            // 투명한 전체 텍스트로 공간 확보
            Text(cleanText)
                .font(.title)
                .foregroundStyle(.clear)
                .multilineTextAlignment(alignment)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            // 실제 표시되는 타이핑 텍스트
            VStack {
                Text(styledDisplayText)
                    .font(.title)
                    .multilineTextAlignment(alignment)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
        }
        .frame(width: max(0, width),
               height: max(0, height),
               alignment: Alignment(horizontal: horizontalAlignment, vertical: .top))
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
