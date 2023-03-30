//
//  ListTypeButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct ListTypeButtonView: View {
    @Binding var listTypeSelected: ListType
    let type: ListType
    let redearProxy: ScrollViewProxy
    @Binding var selectedAnimation: ListType
    let selectedNamespace: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                redearProxy.scrollTo(type.name)
                selectedAnimation = type
            }
            listTypeSelected = type
        } label: {
            VStack {
                Text(type.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(listTypeSelected == type ? .black : .gray)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
        .padding(.bottom, 5)
        .overlay {
            if selectedAnimation == type {
                RoundedRectangle(cornerRadius: 5)
                    .offset(y: 21)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .matchedGeometryEffect(id: "rectangle", in: selectedNamespace)
            }
        }
        .id(type.name)
    }
}

struct ListTypeButtonView_Previews: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { proxy in
            ListTypeButtonView(
                listTypeSelected: .constant(.bestSeller),
                type: .bestSeller,
                redearProxy: proxy,
                selectedAnimation: .constant(.bestSeller),
                selectedNamespace: namespace
            )
        }
    }
}
