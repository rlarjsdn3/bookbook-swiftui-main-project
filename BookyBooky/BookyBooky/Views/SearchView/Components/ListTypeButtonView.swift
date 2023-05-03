//
//  ListTypeButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct ListTypeButtonView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var listTypeSelected: BookListTabItems
    let type: BookListTabItems
    let scrollProxy: ScrollViewProxy
    @Binding var selectedAnimation: BookListTabItems
    let selectedNamespace: Namespace.ID
    
    // MARK: - BODY
    
    var body: some View {
        Button {
            selectType()
        } label: {
            typeLabel
        }
        .padding(.vertical, 10)
        .padding([.horizontal, .bottom], 5)
        .overlay(alignment: .bottom) {
            if selectedAnimation == type {
                underline
            }
        }
    }
}

// MARK: - EXTENSIONS

extension ListTypeButtonView {
    var typeLabel: some View {
        Text(type.name)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(listTypeSelected == type ? .black : .gray)
    }
    
    var underline: some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .matchedGeometryEffect(id: "rectangle", in: selectedNamespace)
    }
}

extension ListTypeButtonView {
    func selectType() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            selectedAnimation = type
            scrollProxy.scrollTo(type.rawValue)
            scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
        }
        listTypeSelected = type
    }
}

// MARK: - PREVIEW

struct ListTypeButtonView_Previews: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { proxy in
            ListTypeButtonView(
                listTypeSelected: .constant(.bestSeller),
                type: .bestSeller,
                scrollProxy: proxy,
                selectedAnimation: .constant(.bestSeller),
                selectedNamespace: namespace
            )
        }
    }
}
