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
    @Namespace var namespace: Namespace.ID
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(bookViewModel.categories, id: \.self) { category in
                    Button {
                        categorySelected = category
                    } label: {
                        Text("\(category.rawValue)")
                    }
                }
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
