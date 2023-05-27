//
//  LeftBottomButtonStyle.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/21.
//

import SwiftUI

struct LeftBottomButtonStyle: ButtonStyle {
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
            .padding(.leading)
    }
}

extension ButtonStyle where Self == LeftBottomButtonStyle {
    static var leftBottomButtonStyle: Self {
        return Self()
    }
}
