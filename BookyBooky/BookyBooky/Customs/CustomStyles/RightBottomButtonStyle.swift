//
//  RightBottomButtonStyle.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/21.
//

import SwiftUI

struct RightBottomButtonStyle: ButtonStyle {
    let backgroundColor: Color
    
    init(backgroundColor: Color = .customDarkGray) {
        self.backgroundColor = backgroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(backgroundColor == .customDarkGray ? .black : .white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(15)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .padding(.trailing)
    }
}

extension ButtonStyle where Self == RightBottomButtonStyle {
    static var rightBottomButtonStyle: Self {
        return Self()
    }
}
