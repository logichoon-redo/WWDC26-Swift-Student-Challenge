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

struct PageNavigationButton<Destination: View>: View {
    let direction: NavigationDirection
    let destination: () -> Destination
    
    init(
        direction: NavigationDirection,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.direction = direction
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack {
                if direction == .next {
                    Text("NEXT")
                }
                
                Image(systemName: iconName)
                
                if direction == .prev {
                    Text("PREV")
                }
            }
            .font(.system(size: .smallFontSize))
            .foregroundStyle(.white.opacity(0.8))
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
