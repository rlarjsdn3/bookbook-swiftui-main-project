//
//  SearchSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchSheetView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var query = ""
    
    @State private var bookCategorySelected: BookCategory = .all
    
    var filteredSearchBookList: [BookSearch.Item] {
        var filter: [BookSearch.Item] = []
        
        if let bookSearchList = viewModel.bookSearchList {
            if bookCategorySelected == .all {
                return bookSearchList.item
            } else {
                for item in bookSearchList.item where item.category == bookCategorySelected {
                    filter.append(item)
                }
            }
        }
        
        return filter
    }
    
    var body: some View {
        VStack {
            SearchSheetTextFieldView(query: $query)
            
            ScrollView {
                HStack {
                    if let bookCategory = viewModel.bookCategory {
                        ForEach(bookCategory, id: \.self) { category in
                            Button {
                                bookCategorySelected = category
                            } label: {
                                Text("\(category.rawValue)")
                            }

                        }
                    }
                }
                
                VStack {
                        ForEach(filteredSearchBookList, id: \.self) { item in
                            Text("\(item.title)")
                        }
                }
            }
            
            
        }
    }
}

struct SearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetView()
            .environmentObject(ViewModel())
    }
}
