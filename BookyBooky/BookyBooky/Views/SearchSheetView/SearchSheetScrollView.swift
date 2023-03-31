//
//  SearchSheetScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct SearchSheetScrollView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var categorySelected: Category
    
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
        ScrollView {
            ForEach(filteredSearchItems, id: \.self) { item in
                Text("\(item.title)")
            }
        }
    }
}

struct SearchSheetScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetScrollView(categorySelected: .constant(.all))
            .environmentObject(BookViewModel())
    }
}
