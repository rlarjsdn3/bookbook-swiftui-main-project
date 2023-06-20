//
//  ListTypeButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchListTabButton: View {
    
    // MARK: - PROPERTIES
    
    @Binding var listTypeSelected: BookListTab
    let type: BookListTab
    let scrollProxy: ScrollViewProxy
    @Binding var selectedAnimation: BookListTab
    let selectedNamespace: Namespace.ID
    
    // MARK: - BODY
    
    var body: some View {
        searchTabButton
    }
}

// MARK: - EXTENSIONS

extension SearchListTabButton {
    var searchTabButton: some View {
        Button {
            selectListType()
        } label: {
            listTypeLabel
        }
        .padding(.vertical, 10)
        .padding([.horizontal, .bottom], 5)
        .overlay(alignment: .bottom) {
            if selectedAnimation == type {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .matchedGeometryEffect(id: "rectangle", in: selectedNamespace)
            }
        }
    }
    
    func selectListType() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            selectedAnimation = type
            scrollProxy.scrollTo(type.rawValue)
            scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
        }
        listTypeSelected = type
    }
    
    var listTypeLabel: some View {
        Text(type.name)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(listTypeSelected == type ? .black : .gray)
    }
}

// MARK: - PREVIEW

struct SearchTabButton_Previews: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { proxy in
            SearchListTabButton(
                listTypeSelected: .constant(.bestSeller),
                type: .bestSeller,
                scrollProxy: proxy,
                selectedAnimation: .constant(.bestSeller),
                selectedNamespace: namespace
            )
        }
    }
}
