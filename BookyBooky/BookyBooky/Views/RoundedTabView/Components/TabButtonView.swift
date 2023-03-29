//
//  TabButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct TabButtonView: View {
    @Binding var selected: TabItem
    var item: TabItem
    var namespace: Namespace.ID
    
    var body: some View {
        Spacer()
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selected = item
            }
            Haptics.shared.play(.light)
        } label: {
            VStack(spacing: -5) {
                Image(systemName: "\(item.icon)")
                    .font(.title3)
                    .offset(y: selected == item ? -8 : 0)
                    .foregroundColor(selected == item ? item.colorPressed : item.color)
                    .scaleEffect(selected == item ? 1.0 : 0.95)
                
                if selected == item {
                    Text("\(item.name)")
                        .font(.caption2)
                        .foregroundColor(.black)
                }
            }
            .frame(height: 20)
            .padding(.bottom, 5)
            .overlay {
                if selected == item {
                    TabShape()
                        .foregroundColor(.black)
                        .frame(width: 40, height: 5)
                        .offset(y: -32)
                        .matchedGeometryEffect(id: "tabShape", in: namespace)
                }
            }
        }
        Spacer()
    }
}

struct TabButtonView_Previews: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        TabButtonView(selected: .constant(.home), item: .home, namespace: namespace)
    }
}
