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
    @Environment(SoundManager.self) private var soundManager
    
    @State private var showHintSheet = false
    @State private var showCorrectGIF = false
    
    let sceneNumber: Int
    let currentStep: StoryStep
    
    private var config: SceneConfig {
        SceneConfig.config(for: sceneNumber)
    }
    
    private var quizInfo: QuizInfo? {
        StoryData.quizzes[currentStep]
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
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
                                .foregroundStyle(.yellow.opacity(0.8))
                        }
                        
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width:1, height: 50)
                        
                        switch quiz.quizType {
                        case .grid:
                            grideOptions(quiz: quiz)
                        case .stack:
                            stackOptions(quiz: quiz)
                        }
                        
                        if quiz.id.hasPrefix("bc") {
                            hintButton(quiz: quiz)
                        } else {
                            if config.ambientAudio != nil {
                                replayButton()
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                if showCorrectGIF {
                    VStack {
                        Spacer()
                        
                        GIFImageView(gifName: "viaductk")
                            .frame(width: geo.size.width)
                            .clipped()
                            .allowsHitTesting(false)
                            .transition(.opacity)
                    }
                    .ignoresSafeArea()
                }
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
        }
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
            let nextStep = quiz.nextStep(for: index)
            if quiz.correctIndices.contains(index) {
                showCorrectGIF = true
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    showCorrectGIF = false
                    navigationManager.navigationTo(step: nextStep)
                }
            } else {
                navigationManager.navigationTo(step: nextStep)
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
        let isUsed = navigationManager.replayUsedScenes.contains(sceneNumber)
        Button {
            if sceneNumber != 2 {
                Task {
                    if let lastStep = StoryData.messages[.scene(number: sceneNumber, phase: .tts)] {
                        let text = lastStep.text
                        await soundManager.speakWithSigh(text: text)
                    }
                }
            } else {
                navigationManager.replayUsedScenes.insert(sceneNumber)
                navigationManager.navigationTo(step: .scene(number: 2, phase: .dialogue(page: 12)))
            }
        } label: {
            HStack {
                Image(systemName: "speaker.wave.2.fill")
                
                Text("Sorry, could you say that again?")
            }
            .font(.body)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.defaultSpacing)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: .defaultCornerRadius))
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .blur(radius: CGFloat(soundManager.audioLevel) * 20)
                    .opacity(isUsed ? 0 : 1)
                    .opacity(Double(soundManager.audioLevel) * 0.6)
            }
        }
        .opacity(isUsed ? 0.3 : 1)
        .disabled(isUsed)
        .padding(.horizontal, .defaultSpacing)
    }
    
    @ViewBuilder
    private func hintButton(quiz: QuizInfo) -> some View {
        if let hintCards = quiz.hintCards {
            Button {
                showHintSheet = true
            } label: {
                ZStack {
                    Circle()
                        .colorMultiply(.white)
                        .blur(radius: 50)
                        .frame(width: 100, height: 100)
                    
                    VStack {
                        CharacterFaceView(character: CharacterExpression.confused,
                                          size: 150, showGradient: false)
                        
                        Text("💡 Need a hint?")
                            .font(.subheadline)
                            .foregroundStyle(.yellow.opacity(0.8))
                    }
                }
            }
            .sheet(isPresented: $showHintSheet) {
                WaysToHelpSheet(title: hintCards.title,
                                cards: hintCards.cards)
            }
        }
    }
}

