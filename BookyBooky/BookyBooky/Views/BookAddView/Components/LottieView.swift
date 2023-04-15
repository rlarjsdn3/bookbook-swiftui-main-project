//
//  LottieView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/15.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: "book")
        animationView.play()
        animationView.loopMode = .repeat(3)
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView()
    }
}
