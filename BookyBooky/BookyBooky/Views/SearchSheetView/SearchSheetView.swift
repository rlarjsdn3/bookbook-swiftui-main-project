//
//  SearchSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI
import AlertToast

struct SearchSheetView: View {
    
    // MARK: - PROPERTIES
    
    let viewType: SearchSheetViewType // 검색 시트 뷰의 성격을 결정하는 변수
    
    // MARK: - WRAPPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @State private var searchQuery = "" // 검색어를 저장하는 변수
    @State private var startIndex = 1   // 검색 결과 시작페이지를 저장하는 변수, 새로운 검색을 시도하는지 안하는지 판별하는 변수
    @State private var selectedCategory: Category = .all    // 선택된 카테고리 정보를 저장하는 변수 (검색 결과 출력용)
    @State private var categoryAnimation: Category = .all   // 카테고리 애니메이션 효과를 위한 변수
    @State private var bookInfoISBN13: String = "" // 검색 리스트에서 선택한 도서의 ISBN13값을 저장하는 변수, 현재 뷰(검색/상세)의 위치를 파악하는 변수
    
    // MARK: - INITALISZER
    
    /*
     * 뷰를 호출하자마자 검색 필드가 보이게 하고 싶은 경우: .searcg(isbn13: "")을 전달
     * 뷰를 호출하자마자 상세 화면을 보이게 하고 싶은 경우: .search(isbn13:) 혹은 .favorite(isbn13:)을 전달
     * 이때, .favorite 타입에서는 isbn13값으로 빈 문자열("")을 전달할 수 없음
     * .search와 .favorite 타입의 차이점은 '뒤로가기'버튼의 유무임
     */
    init(viewType: SearchSheetViewType = .search(isbn13: "")) {
        self.viewType = viewType
        
        switch viewType {
        case .search(let isbn13):
            self._bookInfoISBN13 = State(initialValue: isbn13)
        case .favorite(let isbn13):
            // .favorite타입의 연관된 값으로 빈 문자열("")을 전달 할 수 없음
            guard !isbn13.isEmpty else {
                exit(-1)
            }
            self._bookInfoISBN13 = State(initialValue: isbn13)
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            VStack {
                SearchSheetTextFieldView(
                    searchQuery: $searchQuery,
                    startIndex: $startIndex,
                    bookDetailsISBN13: $bookInfoISBN13,
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
                    startIndex: $startIndex,
                    bookDetailsISBN13: $bookInfoISBN13
                )
            }
            .opacity(!bookInfoISBN13.isEmpty ? 0 : 1)
            
            if !bookInfoISBN13.isEmpty {
                SearchInfoView(isbn13: $bookInfoISBN13, viewType: viewType)
            }
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
            bookInfoISBN13 = "" // 다시 검색 시트를 불러오더라도
            aladinAPIManager.bookSearchItems.removeAll()
            aladinAPIManager.BookInfoItem.removeAll()
        }
        .presentationCornerRadius(30)
    }
}

// MARK: - PREVIEW

struct SearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetView(viewType: .search(isbn13: "9788994492049"))
            .environmentObject(AladinAPIManager())
    }
}
