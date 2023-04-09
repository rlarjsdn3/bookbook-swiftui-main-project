//
//  SearchSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI
import AlertToast

struct SearchSheetView: View {
    
    // MARK: - WRAPPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @State private var searchQuery = "" // 검색어를 저장하는 변수
    @State private var startIndex = 1   // 검색 결과 시작페이지를 저장하는 변수, 새로운 검색을 시도하는지 안하는지 판별하는 변수
    @State private var selectedCategory: Category = .all    // 선택된 카테고리 정보를 저장하는 변수 (검색 결과 출력용)
    @State private var categoryAnimation: Category = .all   // 카테고리 애니메이션 효과를 위한 변수
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            SearchSheetTextFieldView(
                searchQuery: $searchQuery,
                startIndex: $startIndex,
                selectedCategory: $selectedCategory,
                categoryAnimation: $categoryAnimation
            )
            
            SearchSheetCategoryView(
                startIndex: $startIndex,
                selectedCategory: $selectedCategory,
                categoryAnimation: $categoryAnimation
            )
            
            SearchSheetScrollView(
                selectedCategory: $selectedCategory,
                searchQuery: $searchQuery,
                startIndex: $startIndex
            )
        }
        .toast(isPresenting: $aladinAPIManager.showSearchLoading)  {
            AlertToast(
                displayMode: .banner(.pop),
                type: .loading,
                title: "도서 정보 불러오는 중..."
            )
        }
        .toast(isPresenting: $aladinAPIManager.showSearchError, duration: 3.0)  {
            AlertToast(
                displayMode: .banner(.pop),
                type: .error(.red),
                title: "도서 정보 불러오기 실패",
                subTitle: "       잠시 후 다시 시도하십시오."
            )
        }
        .onDisappear {
            aladinAPIManager.bookSearchItems.removeAll()
            aladinAPIManager.BookInfoItem.removeAll()
        }
        .presentationCornerRadius(30)
    }
}

// MARK: - PREVIEW

struct SearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetView()
            .environmentObject(AladinAPIManager())
    }
}
