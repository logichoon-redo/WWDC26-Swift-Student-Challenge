//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/28/26.
//

import SwiftUI

struct LocationToastView: View {
    let text: String
    let textColor: Color
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(textColor.opacity(0.9))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background {
                Capsule()
                    .fill(.ultraThinMaterial)
            }
    }
}
