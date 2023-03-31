//
//  SearchLazyGridView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct SearchLazyGridView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var listTypeSelected: ListType
    
    var bookListItems: [BookList.Item] {
        switch listTypeSelected {
        case .bestSeller:
            return bookViewModel.bestSeller
        case .itemNewAll:
            return bookViewModel.itemNewAll
        case .itemNewSpecial:
            return bookViewModel.itemNewSpecial
        case .blogBest:
            return bookViewModel.blogBest
        }
    }
    
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(bookListItems, id: \.self) { item in
                    ListTypeCellView(bookItem: item)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
}

struct SearchLazyGridView_Previews: PreviewProvider {
    static var previews: some View {
        SearchLazyGridView(listTypeSelected: .constant(.bestSeller))
            .environmentObject(BookViewModel())
    }
}
