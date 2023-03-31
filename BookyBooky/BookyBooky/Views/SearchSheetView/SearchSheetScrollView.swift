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
    @Binding var searchQuery: String
    @Binding var startIndex: Int
    
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
        if !bookViewModel.bookSearchItems.isEmpty {
            ScrollView {
                ForEach(filteredSearchItems, id: \.self) { item in
                    Text("\(item.title)")
                }
                
                Button {
                    startIndex += 1
                    bookViewModel.requestBookSearchAPI(
                        query: searchQuery,
                        page: startIndex
                    )
                } label: {
                    Text("더 보기")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(
                            width: UIScreen.main.bounds.width / 3,
                            height: 40
                        )
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(20)
                }
                .padding(.top, 20)
            }
        } else {
            Text("결과 없음")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxHeight: .infinity)
        }
    }
}

struct SearchSheetScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetScrollView(
            categorySelected: .constant(.all),
            searchQuery: .constant(""),
            startIndex: .constant(1)
        )
        .environmentObject(BookViewModel())
    }
}
