//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/20/26.
//

import SwiftUI

enum QuizType {
    case grid
    case stack
}

@available(iOS 17.0, *)
struct SceneQuizView: View {
    @Environment(StoryNavigationManager.self) private var navigationManager
    let sceneNumber: Int
    let currentStep: StoryStep
    let quizType: QuizType
    
    private var quizInfo: QuizInfo? {
        StoryData.quizzes[currentStep]
    }
    
    var body: some View {
        ZStack {
            Color.black
            
            if let quiz = quizInfo {
                VStack(spacing: .defaultSpacing) {
                    Spacer()
                    
                    Text(quiz.question)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    if let hint = quiz.hint {
                        Text("💡 Hint: \(hint)")
                            .font(.subheadline)
                            .foregroundStyle(.yellow)
                    }
                    
                    Spacer()
                    
                    switch quizType {
                    case .grid:
                        grideOptions(quiz: quiz)
                    case .stack:
                        stackOptions(quiz: quiz)
                    }
                    
                    if quiz.audioFile != nil {
                        replayButton()
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func grideOptions(quiz: QuizInfo) -> some View {
        let columns = 2
        let rows = quiz.options.chunked(into: columns)
        
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                GridRow {
                    ForEach(rows[rowIndex].indices, id: \.self) { colIndex in
                        let optionIndex = rowIndex * columns + colIndex
                        optionButton(text: quiz.options[optionIndex],
                                     index: optionIndex,
                                     quiz: quiz)
                    }
                }
            }
        }
        .padding(.horizontal, .defaultSpacing)
    }
    
    @ViewBuilder
    private func stackOptions(quiz: QuizInfo) -> some View {
        VStack(spacing: .defaultSpacing) {
            ForEach(quiz.options.indices, id: \.self) { index in
                optionButton(text: quiz.options[index],
                             index: index,
                             quiz: quiz)
            }
        }
        .padding(.horizontal, .defaultSpacing)
    }
    
    @ViewBuilder
    private func optionButton(text: String, index: Int, quiz: QuizInfo) -> some View {
        Button {
            if index == quiz.correctIndex {
                navigationManager.navigationTo(step: quiz.correctStep)
            } else {
                navigationManager.navigationTo(step: quiz.wrongStep)
            }
        } label: {
            Text(text)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    @ViewBuilder
    private func replayButton() -> some View {
        Button {
            // TODO: audio replay
        } label: {
            HStack {
                Image(systemName: "speaker.wave.2.fill")
                
                Text("Sorry, could you say that again?")
            }
            .font(.body)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: .defaultCornerRadius))
        }
        .padding(.horizontal, .defaultSpacing)
    }
}
