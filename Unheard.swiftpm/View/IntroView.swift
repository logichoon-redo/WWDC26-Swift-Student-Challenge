//
//  File.swift
//  Unheard
//
//  Created by 이치훈 on 2/12/26.
//

import SwiftUI

struct IntroView: View {
    
    var fullText: String = """
        Hi, I'm Gosan.
        """
    
    init(fullText: String = "") {
        self.fullText = fullText
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                
                VStack(spacing: 50) {
                    Spacer()
                    
                    TypingTextView(text: fullText,
                                   width: geo.size.width,
                                   height: geo.size.height * 0.3,)
                    
                    Spacer()
                    
                    PageNavigationBar(showPrev: false,
                                      prevDestination: {},
                                      nextDestination: {})
                    .padding(.bottom, .largeSpacing)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
}
