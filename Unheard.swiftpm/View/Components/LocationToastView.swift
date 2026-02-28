//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/28/26.
//

import SwiftUI

struct LocationToastView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(Color.black.opacity(0.9))
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .background {
                Capsule()
                    .fill(.ultraThinMaterial)
            }
    }
}
