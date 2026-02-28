//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/19/26.
//

import SwiftUI

struct SceneBackgroundView: View {
    let background: SceneBackground
    var isBlurred: Bool = false
    var showBottomGradient: Bool = true
    var gradientColor: Color = .black
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(background.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width,
                           height: geo.size.height)
                    .clipped()
                    .blur(radius: isBlurred ? 5 : 0)
                
                if isBlurred {
                    Color.black.opacity(0.6)
                }
                
                // 하단 그라데이션 (텍스트 가독성)
                if showBottomGradient {
                    VStack {
                        Spacer()
                        
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0.0),
                                .init(color: gradientColor, location: 0.2),
                                .init(color: gradientColor, location: 1.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: geo.size.height * 0.5)                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}
