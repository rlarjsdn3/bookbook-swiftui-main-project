//
//  FavoriteBooksScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/10.
//

import SwiftUI
import RealmSwift

struct FavoriteBooksScrollView: View {
    
    // MARK: - CONSTANT PROPERTIES
    
    let coulmns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - COMPUTED PROPERTIES
    
    var sortedFavoritesBooks: [FavoriteBook] {
        switch selectedSort {
        // 최근 추가된 순으로 정렬
        case .latestOrder:
            return favoriteBooks.reversed()
        // 제목 오름차순으로 정렬
        case .titleOrder:
            return favoriteBooks.sorted { $0.title < $1.title }
        // 판매 포인트 내림차순으로 정렬
        case .sellingPointOrder:
            return favoriteBooks.sorted { $0.salesPoint.toInteger > $1.salesPoint.toInteger }
        }
    }
    
    var filteredFavroriteBooks: [FavoriteBook] {
        if !searchQuery.isEmpty {
            let filteredFavoriteBooks = sortedFavoritesBooks.filter {
                $0.title.contains(searchQuery) || $0.author.contains(searchQuery)
            }
            return filteredFavoriteBooks
        } else {
            return sortedFavoritesBooks
        }
    }
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    // MARK: - PROPERTIES
    
    @Binding var selectedSort: SortBy
    @Binding var searchQuery: String
    
    var body: some View {
        if !filteredFavroriteBooks.isEmpty {
            ScrollView {
                LazyVGrid(columns: coulmns) {
                    ForEach(filteredFavroriteBooks) { favoriteBook in
                        FavoriteBookCellView(favoriteBook: favoriteBook)
                    }
                }
                .id("Scroll_To_Top")
                .padding(.horizontal, 10)
            }
        } else {
            noResultLabel
        }
    }
}

extension FavoriteBooksScrollView {
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

struct FavoriteBooksScrollView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteBooksScrollView(
            selectedSort: .constant(.latestOrder),
            searchQuery: .constant("")
        )
    }
}
