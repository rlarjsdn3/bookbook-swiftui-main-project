//
//  SearchSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchSheetView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var query = ""
    @State private var categorySelected: Category = .all
    @State private var selectedAnimation: Category = .all
    
    var filteredSearchItems: [BookSearch.Item] {
        var list: [BookSearch.Item] = []
        
        // '전체' 혹은 해당 분류에 맞게 도서를 모으기
        if categorySelected == .all {
            return bookViewModel.bookSearchItems
        } else {
            for item in bookViewModel.bookSearchItems where item.category == categorySelected {
                list.append(item)
            }
        }
        
        return list
    }
    
    var body: some View {
        VStack {
            SearchSheetTextFieldView(query: $query, categorySelected: $categorySelected, animationSelected: $selectedAnimation)
            
            SearchCategoryView(categorySelected: $categorySelected, selectedAnimation: $selectedAnimation)
            
            ZStack {
                ScrollView {
                    ForEach(filteredSearchItems, id: \.self) { item in
                        Text("\(item.title)")
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct SearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetView()
            .environmentObject(BookViewModel())
    }
}
