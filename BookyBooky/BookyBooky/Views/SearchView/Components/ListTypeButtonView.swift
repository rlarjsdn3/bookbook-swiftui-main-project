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
            VStack {
                Text(type.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(selected == type ? .black : .gray)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
        .padding(.bottom, 5)
        .overlay {
            if selected == type {
                RoundedRectangle(cornerRadius: 5)
                    .offset(y: 21)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
            }
        }
    }
}

struct ListTypeButtonView_Previews: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        ListTypeButtonView(selected: .constant(.itemNewAll), type: .itemNewAll, namespace: namespace)
    }
}
