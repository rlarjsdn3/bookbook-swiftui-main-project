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
    
    var bookList: BookList? {
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
            
            ListTypeView(listTypeSelected: $listTypeSelected)

            ZStack {
                Color("Background")
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        if let list = bookList {
                            ForEach(list.item, id: \.self) { item in
                                Text("\(item.title)")
                            }
                        } else {
                            Text("결과 없음")
                        }
                    }
                }
            }
            
            Spacer()
        }
        .onAppear {
            bookViewModel.requestBookListAPI(type: listTypeSelected)
        }
        .onChange(of: listTypeSelected) { selected in
            bookViewModel.requestBookListAPI(type: selected)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(BookViewModel())
    }
}
