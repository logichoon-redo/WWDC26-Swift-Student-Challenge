//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/13/26.
//

import SwiftUI

@available(iOS 17.0, *)
@Observable
@MainActor
class StoryNavigationManager {
    var path = NavigationPath()
    var replayUsedScenes: Set<Int> = []
    private var isNavigating = false
    
    func navigationTo(step: StoryStep) {
        guard !isNavigating else { return }
        isNavigating = true
        path.append(step)
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.3))
            self.isNavigating = false
        }
    }
    
    func goBack() {
        guard !path.isEmpty else { return }
        isNavigating = true
        path.removeLast()
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.3))
            self.isNavigating = false
        }
    }
    
    func reset() {
        path = NavigationPath()
    }
    
    func popTo(count: Int) {
        path.removeLast(count)
    }
}
