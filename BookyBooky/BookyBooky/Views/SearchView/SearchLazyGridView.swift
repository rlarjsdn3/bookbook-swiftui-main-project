//
//  SearchLazyGridView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct SearchLazyGridView: View {
    
    // MARK: - PROPERTIES
    
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
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var listTypeSelected: ListType
    
    // MARK: - BODY
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                lazyGridCells
            }
            // 도서 리스트 타입이 변경될 때마다 리스트의 스크롤을 맨 위로 올림
            .onChange(of: listTypeSelected) { _ in
                withAnimation {
                    proxy.scrollTo("Scroll_To_Top", anchor: .top)
                }
            }
        }
    }
}

// MARK: - EXTENSIONS

extension SearchLazyGridView {
    var lazyGridCells: some View {
        LazyVGrid(columns: columns, spacing: 25) {
            ForEach(bookListItems, id: \.self) { item in
                ListTypeCellView(bookItem: item)
            }
        }
        // 하단 사용자화 탭 뷰가 기본 탭 뷰와 높이가 상이하기 때문에 위/아래 간격을 달리함
        .padding(.top, 20)
        .padding(.bottom, 40)
        .padding(.horizontal, 10)
        .id("Scroll_To_Top")
    }
}

struct SearchLazyGridView_Previews: PreviewProvider {
    static var previews: some View {
        SearchLazyGridView(listTypeSelected: .constant(.bestSeller))
            .environmentObject(BookViewModel())
    }
}
