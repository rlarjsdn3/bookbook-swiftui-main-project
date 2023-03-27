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
        } label: {
            VStack(spacing: -5) {
                Image(systemName: "\(item.icon)")
                    .offset(y: selected != item ? 0 : -8)
                    .foregroundColor(selected != item ? item.color : item.colorPressed)
                
                if selected == item {
                    Text("\(item.name)")
                        .font(.caption2)
                        .foregroundColor(.black)
                }
            }
            .frame(height: 20)
            .overlay {
                if selected == item {
                    TabShape()
                        .foregroundColor(.black)
                        .frame(width: 40, height: 5)
                        .offset(y: -29)
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
