//
//  ScrollYOffset.swift
//  BookyBooky
//
//  Created by 김건우 on 6/14/23.
//

import SwiftUI

struct TrackScrollYOffset: ViewModifier {
    @Binding var startOffset: CGFloat
    @Binding var scrollYOffset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                GeometryReader { proxy -> Color in
                    DispatchQueue.main.async {
                        let globalMinX = proxy.frame(in: .global).minY
                        if startOffset == 0.0 {
                            self.startOffset = globalMinX
                        }
                        withAnimation(.easeInOut(duration: 0.1)) {
                            scrollYOffset = startOffset - globalMinX
                        }
                        
                        print("yOffset: \(scrollYOffset)")
                    }
                    return Color.clear
                }
                .frame(width: 0, height: 0)
            }
    }
}

extension View {
    func trackScrollYOffet(_ startOffset: Binding<CGFloat>, scrollYOffset: Binding<CGFloat>) -> some View {
        modifier(TrackScrollYOffset(startOffset: startOffset, scrollYOffset: scrollYOffset))
    }
}
