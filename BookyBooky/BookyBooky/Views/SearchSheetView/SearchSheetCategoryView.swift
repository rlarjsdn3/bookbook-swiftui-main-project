//
//  SearchCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/30.
//

import SwiftUI

struct SearchSheetCategoryView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var selectedCategory: Category
    @Binding var categoryAnimation: Category
    
    @Namespace var categoryNamespace: Namespace.ID
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                categoryButtons(scrollProxy: proxy)
            }
            .frame(height: 35)
        }
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
            }
        }
    }
}

struct SearchSheetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetCategoryView(
            selectedCategory: .constant(.all),
            categoryAnimation: .constant(.all)
        )
        .environmentObject(BookViewModel())
    }
}
