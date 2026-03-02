//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/25/26.
//

import SwiftUI

@available(iOS 17.0, *)
struct OutroDialogueView: View {
    @State private var showButton = false
    @Environment(StoryNavigationManager.self) private var navigationManager
    @Environment(SoundManager.self) private var soundManager
    @Environment(LanguageManager.self) private var langManager
    
    let currentStep: StoryStep

    private var storyInfo: StoryInfo? {
        langManager.messages[currentStep]
    }
    
    private var bcQuizzes: [(emoji: String, title: String, step: StoryStep)] {
        langManager.current == .korean
        ? [("☕️", "카페", .scene(number: 1, phase: .quiz(page: 2))),
           ("🚇", "지하철", .scene(number: 2, phase: .quiz(page: 2))),
           ("💼", "팀 회의", .scene(number: 3, phase: .quiz(page: 2)))]
        : [("☕️", "Coffee Shop", .scene(number: 1, phase: .quiz(page: 2))),
           ("🚇", "Subway", .scene(number: 2, phase: .quiz(page: 2))),
           ("💼", "Team Meeting", .scene(number: 3, phase: .quiz(page: 2)))]
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    if let story = storyInfo {
                        TypingTextView(text: story.text,
                                       width: max(0, geo.size.width - (.defaultSpacing * 2)),
                                       height: max(0, geo.size.height * 0.25),
                                       alignment: .center,
                                       onComplete: { completed in
                            if completed {
                                withAnimation(.easeOut(duration: 0.3).delay(0.3)) {
                                    showButton = true
                                }
                            }
                        })
                        .padding(.horizontal, .defaultSpacing)
                        
                        CharacterFaceView(character: story.expression)
                        
                        VStack(spacing: 12) {
                            Text(langManager.tryAgain)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.5))
                            
                            HStack(spacing: 16) {
                                ForEach(bcQuizzes, id: \.title) { quiz in
                                    Button {
                                        navigationManager.isReplayFromOutro = true
                                        navigationManager.navigationTo(step: quiz.step)
                                    } label: {
                                        VStack(spacing: 6) {
                                            Text(quiz.emoji)
                                                .font(.title)
                                            
                                            Text(quiz.title)
                                                .font(.caption2)
                                                .foregroundStyle(.white.opacity(0.7))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.white.opacity(0.1))
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, .defaultSpacing)
                        }
                        .opacity(showButton ? 1 : 0)
                        .disabled(!showButton)
                        
                        Button {
                            soundManager.stop()
                            navigationManager.reset()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.counterclockwise")
                                Text(langManager.experienceAgain)
                            }
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white.opacity(0.8))
                            .phaseAnimator([0.4, 1.0]) { content, phase in
                                content.opacity(phase)
                            } animation: { _ in
                                    .easeInOut(duration: 1.5)
                            }
                        }
                        .opacity(showButton ? 1 : 0)
                        .disabled(!showButton)
                        .padding(.bottom, .largeSpacing)
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                showButton = false
            }
            .task {
                guard let storyInfo else { return }
                let suffix = String(storyInfo.id.suffix(2))
                
                switch suffix {
                case "ls", "o1", "o2", "o3":
                    await soundManager.fadeOutAmbient()
                default: break
                }
            }
        }
    }
}
