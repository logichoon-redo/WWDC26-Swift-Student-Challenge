//
//  SceneBackGround.swift
//  Unheard
//
//  Created by 이치훈 on 2/19/26.
//

// MARK: - SceneBackGround
enum SceneBackground {
    case coffeeShop // Scene 1
    case subway // Scene 2
    case meeting // Scene 3
    case custom(imageName: String)
    
    var imageName: String {
        switch self {
        case .coffeeShop: "coffeeShopBackground"
        case .subway: "subwayBackground"
        case .meeting: "officeBackground"
        case .custom(let name): name
        }
    }
}

// MARK: - NPCCharacter
protocol CharacterImageProvider {
    var imageName: String { get }
}

enum CharacterExpression: CharacterImageProvider {
    /// 물음표 표정
    case confused
    /// 공감 표정
    case empathetic
    /// 입 벌리며 웃는 표정
    case excited
    /// 희미한 미소 표정
    case happy
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

enum NPCCharacter: CharacterImageProvider {
    case barista
    case speaker
    case manager
    case gosan(expression: CharacterExpression = .confused)
    case none
    
    var imageName: String {
        switch self {
        case .barista: "barista"
        case .speaker: "speaker"
        case .manager: "manager"
        case .gosan(let expression): expression.imageName
        case .none: ""
        }
    }
}

// MARK: - SceneConfig
struct SceneConfig {
    let background: SceneBackground
    let npc: NPCCharacter
    let ambientAudio: AmbientAudio?
    
    static func config(for sceneNumber: Int) -> SceneConfig {
        switch sceneNumber {
        case 1: SceneConfig(background: .coffeeShop,
                            npc: .barista,
                            ambientAudio: .coffeeShop)
        case 2: SceneConfig(background: .subway,
                            npc: .speaker,
                            ambientAudio: .subway)
        case 3: SceneConfig(background: .meeting,
                            npc: .manager,
                            ambientAudio: .office)
        default: SceneConfig(background: .coffeeShop,
                             npc: .none,
                             ambientAudio: nil)
        }
    }
}

// MARK: - AmbientAudio
enum AmbientAudio {
    case coffeeShop
    case subway
    case office
    
    var audioName: String {
        switch self {
        case .coffeeShop: "coffeeShopAmbient"
        case .subway: "subwayAmbient"
        case .office: "officeAmbient"
        }
    }
}
