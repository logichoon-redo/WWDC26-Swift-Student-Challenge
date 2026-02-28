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
    var stepStack: [StoryStep] = []
    var replayUsedScenes: Set<Int> = []
    var isReplayFromOutro = false
    private var isNavigating = false
    var isTransitioning = false
    
    var currentStep: StoryStep {
        stepStack.last ?? .headPhoneCheck
    }
    
    func navigationTo(step: StoryStep) {
        guard !isNavigating else { return }
        isNavigating = true
        
        withAnimation(.easeInOut(duration: 0.15)) {
            isTransitioning = true
        }
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.15))
            self.stepStack.append(step)
            
            try? await Task.sleep(for: .seconds(0.08))
            withAnimation(.easeIn(duration: 0.15)) {
                self.isTransitioning = false
            }
            
            try? await Task.sleep(for: .seconds(0.2))
            self.isNavigating = false
        }
    }
    
    func goBack() {
        guard !stepStack.isEmpty, !isNavigating else { return }
        isNavigating = true
        
        withAnimation(.easeOut(duration: 0.15)) {
            isTransitioning = true
        }
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.15))
            self.stepStack.removeLast()
            
            try? await Task.sleep(for: .seconds(0.08))
            withAnimation(.easeIn(duration: 0.15)) {
                self.isTransitioning = false
            }
            
            try? await Task.sleep(for: .seconds(0.2))
            self.isNavigating = false
        }
    }
    
    func reset() {
        isNavigating = false
        withAnimation(.easeOut(duration: 0.2)) {
            isTransitioning = true
        }
        
        Task {
            try? await Task.sleep(for: .seconds(0.2))
            self.stepStack.removeAll()
            
            withAnimation(.easeIn(duration: 0.25)) {
                self.isTransitioning = false
            }
        }
    }
    
    func popTo(count: Int) {
        guard stepStack.count >= count, !isNavigating else { return }
        isNavigating = true
        
        withAnimation(.easeOut(duration: 0.15)) {
            isTransitioning = true
        }
        
        Task {
            try? await Task.sleep(for: .seconds(0.15))
            self.stepStack.removeLast(count)
            
            try? await Task.sleep(for: .seconds(0.08))
            withAnimation(.easeIn(duration: 0.15)) {
                self.isTransitioning = false
            }
            
            try? await Task.sleep(for: .seconds(0.2))
            self.isNavigating = false
        }
    }
    
    func returnToOutro() {
        guard !isNavigating else { return }
        isNavigating = true
        
        withAnimation(.easeOut(duration: 0.15)) {
            isTransitioning = true
        }
        
        Task {
            try? await Task.sleep(for: .seconds(0.15))
            while let last = self.stepStack.last, last != .outro(page: 1) {
                self.stepStack.removeLast()
            }
            
            try? await Task.sleep(for: .seconds(0.08))
            withAnimation(.easeIn(duration: 0.15)) {
                self.isTransitioning = false
            }
            
            try? await Task.sleep(for: .seconds(0.2))
            self.isNavigating = false
        }
    }
}
