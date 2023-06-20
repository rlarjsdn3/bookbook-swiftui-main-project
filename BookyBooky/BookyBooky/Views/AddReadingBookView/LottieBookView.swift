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
        let lottie = LottieAnimationView(name: "book")
        lottie.play()
        lottie.loopMode = .repeat(10)
        lottie.contentMode = .scaleAspectFit
        return lottie
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieBookView()
    }
}
