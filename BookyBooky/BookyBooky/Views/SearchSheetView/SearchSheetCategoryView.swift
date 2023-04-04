//
//  SearchCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/30.
//

import SwiftUI

struct SearchSheetCategoryView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var selectedCategory: Category
    @Binding var categoryAnimation: Category
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Namespace var categoryNamespace: Namespace.ID
    
    // MARK: - BODY
    
    var body: some View {
        if !bookViewModel.bookSearchItems.isEmpty {
            scrollCategoryButtons
        } else {
            emptyView
        }
    }
}

// MARK: - EXTENSIONS

extension SearchSheetCategoryView {
    var scrollCategoryButtons: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                categoryButtons(scrollProxy: proxy)
            }
            .frame(height: 35)
        }
    }
    
    var emptyView: some View {
        EmptyView()
    }
}

extension SearchSheetCategoryView {
    @ViewBuilder
    func categoryButtons(scrollProxy: ScrollViewProxy) -> some View {
        HStack(spacing: -20) {
            ForEach(bookViewModel.categories, id: \.self) { category in
                CategoryButtonView(
                    selectedCategory: $selectedCategory,
                    category: category,
                    categoryAnimation: $categoryAnimation,
                    categoryNamespace: categoryNamespace,
                    scrollProxy: scrollProxy
                )
                .id(category.rawValue)
            }
        }
    }
}

// MARK: - PREVIEW

struct SearchSheetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetCategoryView(
            selectedCategory: .constant(.all),
            categoryAnimation: .constant(.all)
        )
        .environmentObject(BookViewModel())
    }
}
