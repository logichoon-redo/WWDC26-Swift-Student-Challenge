//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/27/26.
//

import SwiftUI

struct WaysToHelpSheet: View {
    let title: String
    let cards: [HintCard]
    @Environment(\.dismiss) private var dismiss
    
    @State private var visibleCardCount = 0
    @State private var showButton = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: .defaultSpacing) {
                Spacer()
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                    .frame(height: .smallSpacing)
                
                ForEach(cards.indices, id: \.self) { index in
                    if index < visibleCardCount {
                        hintCardView(card: cards[index])
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                
                Spacer()
                
                if showButton {
                    Button {
                        dismiss()
                    } label: {
                        Text("Got it!")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, .defaultSpacing)
                    .transition(.opacity)
                }
                
                Spacer()
                    .frame(height: .smallSpacing)
            }
        }
        .task {
            await animateCards()
        }
    }
    
    private func animateCards() async {
        for i in 1...cards.count {
            try? await Task.sleep(for: .seconds(0.4))
            
            withAnimation(.easeOut(duration: 0.4)) {
                visibleCardCount = i
            }
        }
        
        try? await Task.sleep(for: .seconds(0.3))
        withAnimation(.easeOut(duration: 0.3)) {
            showButton = true
        }
    }
    
    @ViewBuilder
    private func hintCardView(card: HintCard) -> some View {
        VStack(alignment: .leading, spacing: .smallSpacing) {
            HStack(spacing: .smallSpacing) {
                Text(card.emoji)
                    .font(.title2)
                
                Text(card.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            
            ForEach(card.descriptions, id: \.self) { desc in
                Text(desc)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, .defaultSpacing)
    }
}
