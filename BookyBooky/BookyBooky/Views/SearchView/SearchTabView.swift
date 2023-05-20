//
//  BookListCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var selectedAnimation = BookListTabTypes.bestSeller
    
    @Binding var scrollYOffset: CGFloat
    @Binding var selectedListType: BookListTabTypes
    @Namespace var namespace: Namespace.ID
    
    init(_ scrollYOffset: Binding<CGFloat>, selectedListType: Binding<BookListTabTypes>) {
        self._scrollYOffset = scrollYOffset
        self._selectedListType = selectedListType
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookListTypeButtons
    }
}

// MARK: - EXTENSIONS

extension SearchTabView {
    var bookListTypeButtons: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(BookListTabTypes.allCases, id: \.self) { type in
                        SearchTabButton(
                            listTypeSelected: $selectedListType,
                            type: type,
                            scrollProxy: scrollProxy,
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
    }
}

// MARK: - PREVIEW

struct SearchTabView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTabView(.constant(0.0), selectedListType: .constant(.itemNewAll))
    }
}
