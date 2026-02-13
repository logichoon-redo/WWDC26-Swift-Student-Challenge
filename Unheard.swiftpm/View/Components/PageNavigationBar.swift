//
//  PageNavigationBar.swift
//  Unheard
//
//  Created by 이치훈 on 2/13/26.
//

import SwiftUI

struct PageNavigationBar<PrevDestination: View, NextDestination: View>: View {
    let showPrev: Bool
    let showNext: Bool
    let prevDestination: () -> PrevDestination
    let nextDestination: () -> NextDestination
    
    init(showPrev: Bool = true,
         showNext: Bool = true,
         @ViewBuilder prevDestination: @escaping () -> PrevDestination,
         @ViewBuilder nextDestination: @escaping () -> NextDestination) {
        self.showPrev = showPrev
        self.showNext = showNext
        self.prevDestination = prevDestination
        self.nextDestination = nextDestination
    }
    
    var body: some View {
        HStack {
            if showPrev {
                PageNavigationButton(direction: .prev,
                                     destination: prevDestination)
            } else {
                Spacer()
                    .frame(width: 44)
            }
            
            Spacer()
            
            if showNext {
                PageNavigationButton(direction: .next,
                                     destination: nextDestination)
            } else {
                Spacer()
                    .frame(width: 44)
            }
        }
        .padding(.horizontal, .defaultSpacing)
    }
}
