//
//  NavigationBarItemStyle.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/09.
//

import SwiftUI

struct NavigationBarItemStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .padding([.leading, .trailing], 25)
            .padding([.vertical], 10)
    }
}

extension View {    
    func navigationTitleStyle() -> some View {
        modifier(NavigationTitleStyle())
    }
}
