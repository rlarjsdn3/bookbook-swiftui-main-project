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
    
    @State private var isPresentingSearchInfoView = false
    
    // MARK: - PROPERTIES
    
    let coulmns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var inputQuery: String
    @Binding var searchIndex: Int
    @Binding var selectedListMode: ListMode
    @Binding var selectedCategory: Category
    
    // MARK: - COMPUTED PROPERTIES
    
    var filteredSearchBooks: [briefBookItem.Item] {
        var filtered: [briefBookItem.Item] = []
        
        if selectedCategory == .all {
            return aladinAPIManager.searchResults
        } else {
            for item in aladinAPIManager.searchResults
                where item.categoryName.refinedCategory == selectedCategory {
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
            if aladinAPIManager.searchResults.isEmpty {
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
                
                seeMoreButton
            }
            .onChange(of: searchIndex) {
                // 새로운 검색을 시도할 때만 도서 스크롤을 제일 위로 올립니다.
                // '더 보기' 버튼을 클릭해도 도서 스크롤이 이동하지 않습니다.
                if searchIndex == 1 {
                    withAnimation {
                        scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                    }
                }
            }
            .onChange(of: selectedCategory) {
                withAnimation {
                    scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
    
    var buttonGroup: some View {
        Group {
            switch selectedListMode {
            case .grid:
                LazyVGrid(columns: coulmns, spacing: 25) {
                    ForEach(filteredSearchBooks, id: \.self) { book in
                        SearchBookButton(book, mode: selectedListMode)
                    }
                }
                .padding()
                .id("Scroll_To_Top")
            case .list:
                LazyVStack {
                    ForEach(filteredSearchBooks, id: \.self) { book in
                        SearchBookButton(book, mode: selectedListMode)
                            .padding(.vertical, 8)
                    }
                }
                .id("Scroll_To_Top")
            }
        }
    }
    
    var seeMoreButton: some View {
        Button {
            searchIndex += 1
            aladinAPIManager.requestBookSearchAPI(
                inputQuery,
                page: searchIndex
            )
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
        SearchSheetScrollView(
            inputQuery: .constant(""),
            searchIndex: .constant(1),
            selectedListMode: .constant(.list),
            selectedCategory: .constant(.all)
        )
        .environmentObject(AladinAPIManager())
    }
}
