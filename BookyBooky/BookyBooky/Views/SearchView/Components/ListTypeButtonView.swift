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
            selectType(type: type)
        } label: {
            typeLabel
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
        .padding(.bottom, 5)
        .overlay {
            if selectedAnimation == type {
                underline
            }
        }
        .id(type.rawValue)
    }
}

extension ListTypeButtonView {
    var typeLabel: some View {
        Text(type.name)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(listTypeSelected == type ? .black : .gray)
    }
    
    var underline: some View {
        RoundedRectangle(cornerRadius: 5)
            .offset(y: 21)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .matchedGeometryEffect(id: "rectangle", in: selectedNamespace)
    }
}

extension ListTypeButtonView {
    func selectType(type: ListType) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            selectedAnimation = type
            redearProxy.scrollTo(type.rawValue)
        }
        listTypeSelected = type
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
