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
    
    var body: some View {
        Spacer()
        Button {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
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
        }
        Spacer()
    }
}

struct TabButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TabButtonView(selected: .constant(.home), item: .home)
    }
}
