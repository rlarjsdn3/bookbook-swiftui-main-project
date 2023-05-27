//
//  BottomButtonStyle.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/19.
//

import SwiftUI

struct BottomButtonStyle: ButtonStyle {
    let backgroundColor: Color
    
    init(backgroundColor: Color = .lightGray) {
        self.backgroundColor = backgroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(backgroundColor == .lightGray ? .black : .white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(15)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .padding(.horizontal)
    }
}

extension ButtonStyle where Self == BottomButtonStyle {
    static var bottomButtonStyle: Self {
        return Self()
    }
}
