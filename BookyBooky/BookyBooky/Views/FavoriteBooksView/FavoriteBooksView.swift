//
//  FavoriteBooksView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/09.
//

import SwiftUI
import AlertToast
import RealmSwift

struct FavoriteBooksView: View {
    
    // MARK: - CONSTANT PROPERTIES
    
    let coulmns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedSort = SortBy.latestOrder
    @State private var searchQuery = ""
    @State var isPresentingShowAll = false
    
    @FocusState var focusedField: Bool
    
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
    
    // MARK: - BODY
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            VStack {
                FavoriteBooksTextFieldView(
                    selectedSort: $selectedSort,
                    query: $searchQuery,
                    isPresentingShowAll: $isPresentingShowAll,
                    scrollProxy: scrollProxy
                )

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
            .overlay(alignment: .bottom) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            searchQuery.removeAll()
                            isPresentingShowAll = false
                        }
                    } label: {
                        Text("모두 보기")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(25)
                    }
                    .offset(y: isPresentingShowAll ? -20 : 100)
            }
            .presentationCornerRadius(30)
        }
    }
}

// MARK: - EXTENSIONS

extension FavoriteBooksView {
    var searchButton: some View {
        Button {
            hideKeyboard()
        } label: {
            Text("검색")
        }
        .padding(.horizontal)
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

// MARK: - PREVIEWS

struct FavoriteBooksView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteBooksView()
    }
}
