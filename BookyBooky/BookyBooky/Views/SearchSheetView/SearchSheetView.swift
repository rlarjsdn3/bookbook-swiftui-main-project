//
//  SearchSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchSheetView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var searchQuery = "" // 검색어를 저장하는 변수
    @State private var startIndex = 1   // 검색 결과 시작페이지를 저장하는 변수
    @State private var selectedCategory: Category = .all    // 선택된 카테고리 정보를 저장하는 변수 (검색 결과 출력용)
    @State private var categoryAnimation: Category = .all   // 카테고리 애니메이션 효과를 위한 변수
    @Binding var tapSearchIsbn13: String // 검색 리스트에서 선택한 도서의 ISBN13값을 저장하는 변수
    
    var body: some View {
        ZStack {
            if tapSearchIsbn13.isEmpty {
                VStack {
                    SearchSheetTextFieldView(
                        searchQuery: $searchQuery,
                        startIndex: $startIndex,
                        selectedCategory: $selectedCategory,
                        categoryAnimation: $categoryAnimation
                    )
                    
                    SearchSheetCategoryView(
                        selectedCategory: $selectedCategory,
                        categoryAnimation: $categoryAnimation
                    )
                    
                    ZStack {
                        SearchSheetScrollView(
                            categorySelected: $selectedCategory,
                            searchQuery: $searchQuery,
                            startIndex: $startIndex,
                            tapSearchIsbn13: $tapSearchIsbn13
                        )
                    }
                }
            } else {
                SearchDetailView(isbn13: $tapSearchIsbn13)
            }
        }
        .onDisappear {
            bookViewModel.bookSearchItems.removeAll()
            bookViewModel.bookDetailInfo.removeAll()
        }
        .presentationCornerRadius(30)
    }
}

struct SearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetView(tapSearchIsbn13: .constant(""))
            .environmentObject(BookViewModel())
    }
}
