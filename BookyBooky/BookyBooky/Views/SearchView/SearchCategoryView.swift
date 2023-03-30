//
//  SearchCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/30.
//

import SwiftUI

struct SearchCategoryView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var selectedAnimation = Category.all
    
    @Binding var categorySelected: Category
    @Namespace var selectedNamespace: Namespace.ID
    
    var body: some View {
        ZStack {
            Color.white
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
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
                .padding(.bottom, 10)
            }
        }
    }
}

struct SearchCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCategoryView(categorySelected: .constant(.all))
            .environmentObject(BookViewModel())
    }
}
