//
//  SearchCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/30.
//

import SwiftUI

struct SearchSheetCategoryView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @Namespace var namespace: Namespace.ID
    
    // MARK: - PROPERTIES
    
    @Binding var searchIndex: Int
    @Binding var selectedCategory: CategoryType
    @Binding var selectedCategoryForAnimation: CategoryType
    
    // MARK: - BODY
    
    var body: some View {
        searchCategory
    }
}

// MARK: - EXTENSIONS

extension SearchSheetCategoryView {
    var searchCategory: some View {
        Group {
            if aladinAPIManager.searchResults.isEmpty {
                EmptyView()
            } else {
                scrollCategoryButtons
            }
        }
    }
    
    var scrollCategoryButtons: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                categoryButtons(scrollProxy: proxy)
            }
            .onChange(of: searchIndex) { _ in
                // 새로운 검색을 시도할 때만 카테고리 스크롤을 제일 앞으로 전진합니다.
                // '더 보기' 버튼을 클릭해도 카테고리 스크롤이 이동하지 않습니다.
                if searchIndex == 1 {
                    withAnimation {
                        proxy.scrollTo("Scroll_To_Leading", anchor: .top)
                    }
                }
            }
            .frame(height: 35)
        }
    }
    
    func categoryButtons(scrollProxy proxy: ScrollViewProxy) -> some View {
        HStack(spacing: -20) {
            ForEach(aladinAPIManager.categories, id: \.self) { type in
                CategoryRoundedButton(
                    type,
                    selectedCategory: $selectedCategory,
                    selectedCategoryForAnimation: $selectedCategoryForAnimation,
                    namespace: namespace,
                    scrollProxy: proxy
                )
                .id(type.rawValue)
            }
            .id("Scroll_To_Leading")
        }
    }
}

// MARK: - PREVIEW

struct SearchSheetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetCategoryView(
            searchIndex: .constant(1),
            selectedCategory: .constant(.all),
            selectedCategoryForAnimation: .constant(.all)
        )
        .environmentObject(AladinAPIManager())
    }
}
