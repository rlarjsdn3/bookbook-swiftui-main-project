//
//  BottomButtonStyle.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/19.
//

import SwiftUI

struct BottomButtonStyle: ButtonStyle {
    let theme: Color
    
    init(theme: Color = Color.gray.opacity(0.2)) {
        self.theme = theme
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(theme == .black ? .white : .black)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(theme)
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
