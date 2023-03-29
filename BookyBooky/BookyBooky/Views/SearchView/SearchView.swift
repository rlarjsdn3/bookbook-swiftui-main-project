//
//  SearchView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var listTypeSelected = BookListType.itemNewAll
    
    var body: some View {
        VStack(spacing: 0) {
            SearchHeaderView()
            
            BookListCategoryView(selected: $listTypeSelected)

            ZStack {
                Color("Background")
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        if let bookItemList = viewModel.bookItemList {
                            ForEach(bookItemList.item, id: \.self) { item in
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
            viewModel.requestBookListAPI(type: listTypeSelected)
        }
        .onChange(of: listTypeSelected) { selected in
            viewModel.requestBookListAPI(type: selected)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(ViewModel())
    }
}
