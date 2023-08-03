//
//  SearchSheetScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct SearchSheetScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var searchSheetViewData: SearchSheetViewData
    
    @State private var isPresentingSearchInfoView = false
    
    // MARK: - PROPERTIES
    
    let coulmns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - COMPUTED PROPERTIES
    
    var filteredSearchBooks: [SimpleBookInfo.Item] {
        var filtered: [SimpleBookInfo.Item] = []
        
        if searchSheetViewData.selectedCategory == .all {
            return searchSheetViewData.bookSearchResult
        } else {
            for item in searchSheetViewData.bookSearchResult
            where item.categoryName.refinedCategory == searchSheetViewData.selectedCategory {
                filtered.append(item)
            }
        }
        
        return filtered
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookScrollContent
    }
}

// MARK: - EXTENSIONS

extension SearchSheetScrollView {
    var bookScrollContent: some View {
        Group {
            if searchSheetViewData.bookSearchResult.isEmpty {
                noResultLabel
            } else {
                bookScroll
            }
        }
    }
    
    var bookScroll: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                buttonGroup
                    .id("Scroll_To_Top")
                
                seeMoreButton
            }
            .onChange(of: searchSheetViewData.searchIndex) { _ in
                // 새로운 검색을 시도할 때만 도서 스크롤을 제일 위로 올립니다.
                // '더 보기' 버튼을 클릭해도 도서 스크롤이 이동하지 않습니다.
                if searchSheetViewData.searchIndex == 1 {
                    withAnimation {
                        scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                    }
                }
            }
            .onChange(of: searchSheetViewData.selectedCategory) { _ in
                withAnimation {
                    scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
    
    var buttonGroup: some View {
        Group {
            switch searchSheetViewData.selectedListMode {
            case .grid:
                LazyVGrid(columns: coulmns, spacing: 25) {
                    ForEach(filteredSearchBooks, id: \.self) { book in
                        SearchBookButton(book, mode: searchSheetViewData.selectedListMode)
                    }
                }
                .padding()
            case .list:
                LazyVStack {
                    ForEach(filteredSearchBooks, id: \.self) { book in
                        SearchBookButton(book, mode: searchSheetViewData.selectedListMode)
                            .padding(.vertical, 8)
                    }
                }
            }
        }
    }
    
    var seeMoreButton: some View {
        Button {
            searchSheetViewData.searchIndex += 1
            alertManager.isPresentingSearchLoadingToastAlert = true
            aladinAPIManager.requestBookSearchResult(
                searchSheetViewData.inputQuery,
                page: searchSheetViewData.searchIndex
            ) { book in
                if let book = book {
                    searchSheetViewData.bookSearchResult.append(contentsOf: book.item)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        alertManager.isPresentingSearchLoadingToastAlert = false
                    }
                } else {
                    alertManager.isPresentingSearchLoadingToastAlert = false
                    alertManager.isPresentingDetailBookErrorToastAlert = true
                }
            }
        } label: {
            Text("더 보기")
                .font(.title3)
                .fontWeight(.bold)
                .frame(
                    width: mainScreen.width / 3,
                    height: 40
                )
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(20)
        }
        .padding(.top, 15)
        // 베젤이 없는 아이폰(iPhone 14 등)은 하단 간격 10으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 하단 간격 30으로 설정
        .padding(.bottom, safeAreaInsets.bottom == 0 ? 30 : 10)
    }
    
    var noResultLabel: some View {
        VStack {
            VStack {
                Text("결과 없음")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxHeight: .infinity)
                
                Text("새로운 검색을 시도하십시오.")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .frame(height: 50)
        }
        .frame(maxHeight: .infinity)
    }
}

// MARK: - PREVIEW

struct SearchSheetScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetScrollView()
            .environmentObject(SearchSheetViewData())
            .environmentObject(AladinAPIManager())
            .environmentObject(AlertManager())
    }
}
