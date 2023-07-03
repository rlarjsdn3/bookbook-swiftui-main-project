//
//  NavigationTitleStyle.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/09.
//

import SwiftUI

struct NavigationTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.semibold)
    }
}

extension View {
    func navigationBarItemStyle() -> some View {
        modifier(NavigationBarItemStyle())
    }
}
