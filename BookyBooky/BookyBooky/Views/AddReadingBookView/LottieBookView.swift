//
//  LottieView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/15.
//

import SwiftUI
import Lottie

struct LottieBookView: UIViewRepresentable {
    func makeUIView(context: Context) -> LottieAnimationView {
        let bookAnimation = LottieAnimationView(name: "book")
        bookAnimation.play()
        bookAnimation.loopMode = .repeat(10)
        bookAnimation.contentMode = .scaleAspectFit
        return bookAnimation
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieBookView()
    }
}
