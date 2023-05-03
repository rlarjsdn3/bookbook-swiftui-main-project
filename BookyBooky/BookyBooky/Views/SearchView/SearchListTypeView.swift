//
//  BookListCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchListTypeView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var selectedAnimation = BookListTabItems.bestSeller
    
    @Binding var listTypeSelected: BookListTabItems
    @Binding var scrollYOffset: CGFloat
    @Namespace var namespace: Namespace.ID
    
    // MARK: - BODY
    
    var body: some View {
        ScrollViewReader { proxy in
            scrollListTypeButtons(scrollProxy: proxy)
        }
    }
}

// MARK: - EXTENSIONS

extension SearchListTypeView {
    @ViewBuilder
    func scrollListTypeButtons(scrollProxy proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            listTypeButtons(scrollProxy: proxy)
        }
    }
    
    @ViewBuilder
    func listTypeButtons(scrollProxy proxy: ScrollViewProxy) -> some View {
        HStack {
            ForEach(BookListTabItems.allCases, id: \.self) { type in
                ListTypeButtonView(
                    listTypeSelected: $listTypeSelected,
                    type: type,
                    scrollProxy: proxy,
                    selectedAnimation: $selectedAnimation,
                    selectedNamespace: namespace
                )
                .id(type.rawValue)
                .padding(.horizontal, 8)
            }
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
        .overlay(alignment: .bottom) {
            Divider()
                .opacity(scrollYOffset > 20.0 ? 1 : 0)
        }
    }
}

// MARK: - PREVIEW

struct SearchListTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListTypeView(listTypeSelected: .constant(.itemNewAll), scrollYOffset: .constant(0.0))
    }
}
