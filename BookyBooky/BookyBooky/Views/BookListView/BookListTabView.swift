//
//  BookListCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct BookListTabView: View {
    
    // MARK: - WRAPPER PROPERTIES

    @EnvironmentObject var bookListViewData: BookListViewData
    
    @Namespace var namespace: Namespace.ID
    
    // MARK: - BODY
    
    var body: some View {
        tabButtonGroup
    }
}

// MARK: - EXTENSIONS

extension BookListTabView {
    var tabButtonGroup: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(BookListTab.allCases, id: \.self) { type in
                        BookListTabButton(
                            type,
                            scrollProxy: proxy,
                            namespace: namespace
                        )
                        .id(type.rawValue)
                        .padding(.horizontal, 8)
                    }
                }
                .padding(.leading, 8)
                .padding(.trailing, 8)
                .overlay(alignment: .bottom) {
                    Divider()
                        .opacity(bookListViewData.scrollYOffset > 20.0 ? 1 : 0)
                }
            }
        }
    }
}

// MARK: - PREVIEW

#Preview {
    BookListTabView()
        .environmentObject(BookListViewData())
}
