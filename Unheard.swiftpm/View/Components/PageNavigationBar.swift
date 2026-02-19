//
//  PageNavigationBar.swift
//  Unheard
//
//  Created by 이치훈 on 2/13/26.
//

import SwiftUI

struct PageNavigationBar: View {
    let showPrev: Bool
    let showNext: Bool
    let prevText: String
    let nextText: String
    let prevDestination: () -> Void
    let nextDestination: () -> Void
    
    init(showPrev: Bool = true,
         showNext: Bool = true,
         prevText: String = "PREV",
         nextText: String = "NEXT",
         prevDestination: @escaping () -> Void,
         nextDestination: @escaping () -> Void) {
        self.showPrev = showPrev
        self.showNext = showNext
        self.prevText = prevText
        self.nextText = nextText
        self.prevDestination = prevDestination
        self.nextDestination = nextDestination
    }
    
    var body: some View {
        ZStack {
            HStack {
                if showPrev {
                    PageNavigationButton(direction: .prev,
                                         text: prevText,
                                         action: prevDestination)
                }
                
                Spacer()
                
                if showNext {
                    PageNavigationButton(direction: .next,
                                         text: nextText,
                                         action: nextDestination)
                }
            }
            .padding(.horizontal, .defaultSpacing)
        }
        .padding(.bottom, .largeSpacing)
    }
}
