//
//  SceneBackGround.swift
//  Unheard
//
//  Created by 이치훈 on 2/19/26.
//

// MARK: SceneBackGround
enum SceneBackground {
    case coffeeShop // Scene 1
    case subway // Scene 2
    case meeting // Scene 3
//    case quiet // Scene 4
    case custom(imageName: String)
    
    var imageName: String {
        switch self {
        case .coffeeShop: "coffeeShopBackground"
        case .subway: "coffeeShopBackground"
        case .meeting: "coffeeShopBackground"
        case .custom(let name): name
        }
    }
}

// MARK: NPCCharacter
enum NPCCharacter: CharacterImageProvider {
    case barista
    case speaker
    case manager
    case gosan(expression: CharacterExpression = .confused)
    case none
    
    var imageName: String {
        switch self {
        case .barista: "barista"
        case .speaker: ""
        case .manager: ""
        case .gosan(let expression): expression.imageName
        case .none: ""
        }
    }
}

// MARK: SceneConfig
struct SceneConfig {
    let background: SceneBackground
    let npc: NPCCharacter
    
    static func config(for sceneNumber: Int) -> SceneConfig {
        switch sceneNumber {
        case 1: SceneConfig(background: .coffeeShop,
                            npc: .barista)
        case 2: SceneConfig(background: .subway,
                            npc: .speaker)
        case 3: SceneConfig(background: .meeting,
                            npc: .manager)
        default: SceneConfig(background: .coffeeShop,
                             npc: .none)
        }
    }
}
