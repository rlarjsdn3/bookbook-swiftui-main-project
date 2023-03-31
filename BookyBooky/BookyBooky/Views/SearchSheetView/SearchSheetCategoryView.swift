//
//  SearchCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/30.
//

import SwiftUI

struct SearchSheetCategoryView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var categorySelected: Category
    @Binding var selectedAnimation: Category
    @Namespace var selectedNamespace: Namespace.ID
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -20) {
                    ForEach(bookViewModel.categories, id: \.self) { category in
                        CategoryButtonView(
                            categorySelected: $categorySelected,
                            category: category,
                            proxyReader: proxy,
                            selectedAnimation: $selectedAnimation,
                            selectedNamespace: selectedNamespace
                        )
                    }
                }
            }
            .frame(height: 35)
        }
    }
}

struct SearchSheetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetCategoryView(
            categorySelected: .constant(.all),
            selectedAnimation: .constant(.all)
        )
        .environmentObject(BookViewModel())
    }
}
