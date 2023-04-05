//
//  SearchSheetScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct SearchSheetScrollView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var selectedCategory: Category
    @Binding var searchQuery: String
    @Binding var startIndex: Int
    @Binding var tapSearchIsbn13: String
    
    // MARK: - COMPUTED PROPERTIES
    
    // 선택된 도서 카테고리에 맞게 리스트를 필터링한 결과를 반환하는 프로퍼티
    var filteredSearchItems: [BookList.Item] {
        var list: [BookList.Item] = []
        
        if selectedCategory == .all {
            return bookViewModel.bookSearchItems
        } else {
            for item in bookViewModel.bookSearchItems where item.category == selectedCategory {
                list.append(item)
            }
        }
        
        return list
    }
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    // MARK: - BODY
    
    var body: some View {
        // 검색 결과가 존재하는 경우
        if !bookViewModel.bookSearchItems.isEmpty {
            scrollSearchItems // 각 검색 도서 셀 출력
        // 검색 결과가 존재하지 않는 경우
        } else {
            noResultLabel // '결과 없음' 뷰 출력
        }
    }
}

// MARK: - EXTENSIONS

extension SearchSheetScrollView {
    var scrollSearchItems: some View {
        ScrollViewReader { proxy in
            ScrollView {
                lazyListCells
                
                seeMoreButton
            }
            .onChange(of: startIndex, perform: { _ in
                // 새로운 검색을 시도할 때만 스크롤을 제일 위로 올립니다.
                // '더 보기' 버튼을 클릭해도 스크롤이 올라가지 않습니다.
                if startIndex == 1 {
                    withAnimation {
                        proxy.scrollTo("Scroll_To_Top", anchor: .top)
                    }
                }
            })
            .onChange(of: selectedCategory) { _ in
                withAnimation {
                    proxy.scrollTo("Scroll_To_Top", anchor: .top)
                }
            }
        }
    }
    
    var lazyListCells: some View {
        LazyVStack {
            ForEach(filteredSearchItems, id: \.self) { item in
                SearchSheetCellView(bookItem: item)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            tapSearchIsbn13 = item.isbn13
                        }
                    }
            }
        }
        .id("Scroll_To_Top")
    }
    
    var seeMoreButton: some View {
        Button {
            startIndex += 1
            bookViewModel.requestBookSearchAPI(
                query: searchQuery,
                page: startIndex
            )
        } label: {
            Text("더 보기")
                .font(.title3)
                .fontWeight(.bold)
                .frame(
                    width: UIScreen.main.bounds.width / 3,
                    height: 40
                )
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(20)
        }
        .padding(.top, 15)
        // 베젤이 없는 아이폰(iPhone 14 등)은 하단 간격 0으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 하단 간격 15으로 설정
        .padding(.bottom, safeAreaInsets.bottom == 0 ? 30 : 0)
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
            selectedCategory: .constant(.all),
            searchQuery: .constant(""),
            startIndex: .constant(1),
            tapSearchIsbn13: .constant("")
        )
        .environmentObject(BookViewModel())
    }
}
