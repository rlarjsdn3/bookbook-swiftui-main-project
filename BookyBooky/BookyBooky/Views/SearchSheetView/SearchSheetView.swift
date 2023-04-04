//
//  SearchSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

/// 실질적인 검색 기능을 수행하는 검색 시트 뷰입니다.  매개 변수로 상세 보기하고자 하는 도서의 ISBN13값을 showInfoIsbn13으로 전달하세요.
/// 만약 뷰를 호출하자마자 검색 필드를 보고 싶으면 빈 문자열("")을 전달하세요. 곧바로 상세 보기를 하고자 한다면 해당 도서의 ISBN13값을 전달하세요.
/// 이렇게 하는 이유는 곧바로 상세 보기를 하더라도 '뒤로 가기'버튼을 클릭하면 검색 필드를 보이게 하기 위함입니다.
struct SearchSheetView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var tapSearchIsbn13: String // 검색 리스트에서 선택한 도서의 ISBN13값을 저장하는 변수
    
    // MARK: - WRAPPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @State private var searchQuery = "" // 검색어를 저장하는 변수
    @State private var startIndex = 1   // 검색 결과 시작페이지를 저장하는 변수
    @State private var selectedCategory: Category = .all    // 선택된 카테고리 정보를 저장하는 변수 (검색 결과 출력용)
    @State private var categoryAnimation: Category = .all   // 카테고리 애니메이션 효과를 위한 변수
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            VStack {
                SearchSheetTextFieldView(
                    searchQuery: $searchQuery,
                    startIndex: $startIndex,
                    tapSearchIsbn13: $tapSearchIsbn13,
                    selectedCategory: $selectedCategory,
                    categoryAnimation: $categoryAnimation
                )
                
                SearchSheetCategoryView(
                    selectedCategory: $selectedCategory,
                    categoryAnimation: $categoryAnimation
                )
                
                SearchSheetScrollView(
                    categorySelected: $selectedCategory,
                    searchQuery: $searchQuery,
                    startIndex: $startIndex,
                    tapSearchIsbn13: $tapSearchIsbn13
                )
            }
            .opacity(!tapSearchIsbn13.isEmpty ? 0 : 1)
            
            if !tapSearchIsbn13.isEmpty {
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

// MARK: - PREVIEW

struct SearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetView(tapSearchIsbn13: .constant(""))
            .environmentObject(BookViewModel())
    }
}
