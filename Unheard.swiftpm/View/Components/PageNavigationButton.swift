//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/13/26.
//

import SwiftUI

enum NavigationDirection {
    case prev
    case next
}

struct PageNavigationButton: View {
    let direction: NavigationDirection
    let action: () -> Void
    let text: String
    let textColor: Color
    
    init(
        direction: NavigationDirection,
        text: String,
        textColor: Color = .white,
        action: @escaping () -> Void
    ) {
        self.direction = direction
        self.text = text
        self.textColor = textColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if direction == .next {
                    Text(text)
                }
                
                Image(systemName: iconName)
                
                if direction == .prev {
                    Text(text)
                }
            }
            .bold()
            .font(.system(size: .smallFontSize))
            .foregroundStyle(textColor.opacity(0.8))
        }
    }
    
    private var iconName: String {
        switch direction {
        case .prev:
            return "arrow.left"
        case .next:
            return "arrow.right"
        }
    }
}
