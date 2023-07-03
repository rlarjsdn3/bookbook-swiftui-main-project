//
//  ScrollYOffset.swift
//  BookyBooky
//
//  Created by 김건우 on 6/14/23.
//

import SwiftUI

struct TrackScrollYOffset: ViewModifier {
    @Binding var startOffset: CGFloat
    @Binding var yOffset: CGFloat
    
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
                            let newYOffset = startOffset - globalMinX
                            // 정수가 서로 다른 경우
                            if Int(yOffset) != Int(newYOffset) {
                                yOffset = newYOffset // yOffset값을 갱신
                            }
                            
                            // NOTE: - 소수점의 변화까지 포착해 yOffset값을 갱신시킨다면,
                            //       - 너무 많이 화면을 새로 리-렌더링을 헤야 하므로 성능 저하가 발생할 수 있습니다.
                            //       - 정수가 다른 경우에만 yOffset값을 갱신시키도록 하였습니다. (2023. 7. 3)
                        }
                        print("yOffset: \(yOffset)")
                    }
                    return Color.clear
                }
                .frame(width: 0, height: 0)
            }
    }
}

extension View {
    func trackScrollYOffet(_ startOffset: Binding<CGFloat>, yOffset: Binding<CGFloat>) -> some View {
        modifier(TrackScrollYOffset(startOffset: startOffset, yOffset: yOffset))
    }
}
