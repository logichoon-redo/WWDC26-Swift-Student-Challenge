//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/14/26.
//

import SwiftUI

protocol CharacterImageProvider {
    var imageName: String { get }
}

enum CharacterExpression: CharacterImageProvider {
    case confused /// 물음표 표정
    case empathetic /// 공감 표정
    case excited /// 입 벌리며 웃는 표정
    case happy /// 희미한 미소 표정
    case none
    
    var imageName: String {
        switch self {
        case .confused: return "gosan_confused"
        case .empathetic: return "gosan_empathetic"
        case .excited: return "gosan_excited"
        case .happy: return "gosan_happy"
        case .none: return ""
        }
    }
}

struct CharacterFaceView: View {
    
    //    var expression: CharacterExpression
    let character: any CharacterImageProvider
    let showGradient: Bool
    var glowLevel: Float
    
    private var glowRadius: CGFloat {
        CGFloat(glowLevel) * 30
    }
    private var glowOpacity: Double {
        Double(glowLevel) * 0.85
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
                .colorMultiply(.cyan)   // 원하는 글로우 색상
                .blur(radius: glowRadius)
                .opacity(glowOpacity)
                .clipped()
            
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
