//
//  ListTypeButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct ListTypeButtonView: View {
    @Binding var selected: ListType
    let type: ListType
    let namespace: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selected = type
            }
        } label: {
            VStack(alignment: .leading, spacing: -5) {
                Text(type.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(selected == type ? .white : .black)
                    .padding(.horizontal, selected == type ? 20 : 0)
                    .padding(.vertical, 5)
                    .background {
                        if selected == type {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.black)
                                .matchedGeometryEffect(id: "rectangle", in: namespace)
                        }
                    }
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)

    }
}

struct ListTypeButtonView_Previews: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        ListTypeButtonView(selected: .constant(.itemNewAll), type: .itemNewAll, namespace: namespace)
    }
}
