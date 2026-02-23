//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/13/26.
//

import SwiftUI

@available(iOS 17.0, *)
@Observable
class StoryNavigationManager {
    var path = NavigationPath()
    var replayUsedScenes: Set<Int> = []
    
    func navigationTo(step: StoryStep) {
        path.append(step)
    }
    
    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func reset() {
        path = NavigationPath()
    }
    
    func popTo(count: Int) {
        path.removeLast(count)
    }
}
