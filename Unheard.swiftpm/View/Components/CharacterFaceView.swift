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
    
    init(character: any CharacterImageProvider, showGradient: Bool = true) {
        self.character = character
        self.showGradient = showGradient
    }
    
    var body: some View {
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
            .frame(width: 300,
                   height: 300)
    }
}
