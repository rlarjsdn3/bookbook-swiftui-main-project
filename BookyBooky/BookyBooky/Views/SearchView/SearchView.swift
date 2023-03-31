//
//  SearchView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var listTypeSelected = ListType.bestSeller
    
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
    
    var body: some View {
        VStack(spacing: 0) {
            SearchHeaderView()
            
            SearchListTypeView(listTypeSelected: $listTypeSelected)

            ZStack {
                Color("Background")
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(bookListItems, id: \.self) { item in
                            ListTypeCellView(bookItem: item)
                        }
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(BookViewModel())
    }
}
