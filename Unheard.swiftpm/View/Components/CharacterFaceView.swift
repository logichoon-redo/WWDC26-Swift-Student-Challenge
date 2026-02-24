//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/14/26.
//

import SwiftUI

struct CharacterFaceView: View {
    
    let character: any CharacterImageProvider
    let showGradient: Bool
    var glowLevel: Float
    
    private var glowRadius: CGFloat {
        CGFloat(glowLevel) * 40
    }
    private var glowOpacity: Double {
        Double(glowLevel) * 0.9
    }
    
    init(character: any CharacterImageProvider, showGradient: Bool = true, glowLevel: Float = 0.0) {
        self.character = character
        self.showGradient = showGradient
        self.glowLevel = glowLevel
    }
    
    var body: some View {
        ZStack {
            Image(character.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .colorMultiply(.white)   // 글로우 색상
                .blur(radius: glowRadius)
                .opacity(glowOpacity)
            
            Image(character.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .overlay {
                    if showGradient {
                        LinearGradient(gradient: Gradient(colors: [
                            .clear,
                            .black
                        ]),
                                       startPoint: .center,
                                       endPoint: .bottom)
                        .frame(width: 190,
                               height: 200)
                    }
                }
            
        }
        .frame(width: 300,
               height: 300)
    }
}
