//
//  SearchCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/30.
//

import SwiftUI

struct SearchSheetCategoryView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var selectedCategory: Category     // 선택된 카테고리 정보를 저장하는 변수 (검색 결과 출력용)
    @Binding var categoryAnimation: Category    // 카테고리 애니메이션 효과를 위한 변수
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: AladinAPIManager
    
    @Namespace var categoryNamespace: Namespace.ID  // 카테고리 버튼 간 애니메이션 효과를 주기 위한 이름 공간 변수
    
    // MARK: - BODY
    
    var body: some View {
        // 검색 결과가 존재하는 경우
        if !bookViewModel.bookSearchItems.isEmpty {
            scrollCategoryButtons // 도서 카테고리 버튼 뷰 출력
        // 검색 결과가 존재하지 않는 경우
        } else {
            emptyView // 빈 공간 뷰 출력
        }
    }
}

// MARK: - EXTENSIONS

extension SearchSheetCategoryView {
    var scrollCategoryButtons: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                categoryButtons(scrollProxy: proxy)
            }
            .frame(height: 35)
        }
    }
    
    var emptyView: some View {
        EmptyView()
    }
}

extension SearchSheetCategoryView {
    @ViewBuilder
    func categoryButtons(scrollProxy: ScrollViewProxy) -> some View {
        HStack(spacing: -20) {
            ForEach(bookViewModel.categories, id: \.self) { category in
                CategoryButtonView(
                    selectedCategory: $selectedCategory,
                    category: category,
                    categoryAnimation: $categoryAnimation,
                    categoryNamespace: categoryNamespace,
                    scrollProxy: scrollProxy
                )
                .id(category.rawValue)
            }
        }
    }
}

// MARK: - PREVIEW

struct SearchSheetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetCategoryView(
            selectedCategory: .constant(.all),
            categoryAnimation: .constant(.all)
        )
        .environmentObject(AladinAPIManager())
    }
}
