//
//  SearchSheetScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct SearchSheetScrollView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var categorySelected: Category
    @Binding var searchQuery: String
    @Binding var startIndex: Int
    @Binding var tapSearchIsbn13: String
    
    // MARK: - COMPUTED PROPERTIES
    
    var filteredSearchItems: [BookList.Item] {
        var list: [BookList.Item] = []
        
        // '전체' 혹은 해당 분류에 맞게 도서를 모으기
        if categorySelected == .all {
            return bookViewModel.bookSearchItems
        } else {
            for item in bookViewModel.bookSearchItems where item.category == categorySelected {
                list.append(item)
            }
        }
        
        return list
    }
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            if !bookViewModel.bookSearchItems.isEmpty {
                scrollSearchItems
            } else {
                noResultLabel
            }
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
            .onChange(of: categorySelected) { _ in
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
            categorySelected: .constant(.all),
            searchQuery: .constant(""),
            startIndex: .constant(1),
            tapSearchIsbn13: .constant("")
        )
        .environmentObject(BookViewModel())
    }
}
