//
//  FavoriteBooksScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/10.
//

import SwiftUI
import RealmSwift

struct BookShelfListScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmMananger: RealmManager
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    @ObservedResults(ReadingBook.self) var readingBooks
    
    // MARK: - COMPUTED PROPERTIES
    
    var filteredFavoriteBooks: [FavoriteBook] {
        favoriteBooks.getFilteredFavoriteBooks(searchQuery: searchQuery, bookSortType: selectedSortType)
    }
    
    var filteredCompleteBooks: [ReadingBook] {
        readingBooks.getFilteredReadingBooks(.complete, searchQuery: searchQuery, bookSortType: selectedSortType)
    }
    
    // MARK: - PROPERTIES
    
    let coulmns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var searchQuery: String
    @Binding var selectedSortType: BookSortCriteriaType
    let viewType: BookShelfListViewType
    
    // MARK: - INITIALIZER
    
    init(searchQuery: Binding<String>, selectedSortType: Binding<BookSortCriteriaType>,
         viewType: BookShelfListViewType) {
        self._searchQuery = searchQuery
        self._selectedSortType = selectedSortType
        self.viewType = viewType
    }
    
    // MARK: - BODY
    
    var body: some View {
        if filteredFavoriteBooks.isEmpty || !filteredCompleteBooks.isEmpty {
            noResultLabel
        } else {
            scrollFavoriteBooks
        }
    }
}

// MARK: - EXTENSIONS

extension BookShelfListScrollView {
    var scrollFavoriteBooks: some View {
        ScrollView {
            LazyVGrid(columns: coulmns, spacing: 15) {
                if viewType == .favorite {
                    ForEach(filteredFavoriteBooks) { favoriteBook in
                        FavoriteBookCellButton(favoriteBook, viewType: .navigation)
                    }
                } else {
                    ForEach(filteredCompleteBooks, id: \.self) { completeBook in
                        ReadingBookCellButton(completeBook, buttonType: .shelf)
                    }
                }
            }
            .id("Scroll_To_Top")
            .padding(.horizontal, 10)
        }
    }
}

extension BookShelfListScrollView {
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

struct FavoriteBooksScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfListScrollView(
            searchQuery: .constant(""),
            selectedSortType: .constant(.latestOrder),
            viewType: .favorite
        )
        .environmentObject(RealmManager())
    }
}