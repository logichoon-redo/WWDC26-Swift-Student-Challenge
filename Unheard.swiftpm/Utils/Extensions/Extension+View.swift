//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/12/26.
//

import SwiftUI

extension View {
    @ViewBuilder
    func sfSymvolAnimated(_ animate: Bool) -> some View {
        if #available(iOS 18, *) {
            self.symbolEffect(.breathe, isActive: animate)
        } else {
            self
                .scaleEffect(animate ? 1.15 : 1.0)
                .opacity(animate ? 1.0 : 0.8)
                .animation(
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                    value: animate
                )
        }
    }
}
