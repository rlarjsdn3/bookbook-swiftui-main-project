//
//  ScrollYOffset.swift
//  BookyBooky
//
//  Created by 김건우 on 6/14/23.
//

import SwiftUI

struct ScrollYOffset: ViewModifier {
    @Binding var startOffset: CGFloat
    @Binding var scrollYOffset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                GeometryReader { proxy -> Color in
                    DispatchQueue.main.async {
                        let offset = proxy.frame(in: .global).minY
                        if startOffset == 0.0 {
                            self.startOffset = offset
                        }
                        withAnimation(.easeInOut(duration: 0.1)) {
                            scrollYOffset = startOffset - offset
                        }
                        
                        print(scrollYOffset)
                    }
                    return Color.clear
                }
                .frame(width: 0, height: 0)
            }
    }
}

extension View {
    func scrollYOffet(_ startOffset: Binding<CGFloat>, scrollYOffset: Binding<CGFloat>) -> some View {
        modifier(ScrollYOffset(startOffset: startOffset, scrollYOffset: scrollYOffset))
    }
}
