//
//  SearchCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/30.
//

import SwiftUI

struct SearchCategoryView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var categorySelected: Category
    @Binding var selectedAnimation: Category
    @Namespace var selectedNamespace: Namespace.ID
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(bookViewModel.categories, id: \.self) { category in
                    CategoryButtonView(
                        categorySelected: $categorySelected,
                        category: category,
                        selectedAnimation: $selectedAnimation,
                        selectedNamespace: selectedNamespace
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 35)
    }
}

struct SearchCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCategoryView(
            categorySelected: .constant(.all),
            selectedAnimation: .constant(.all)
        )
        .environmentObject(BookViewModel())
    }
}
