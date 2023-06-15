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
    
    @ObservedResults(ReadingBook.self) var readingBooks
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    // MARK: - COMPUTED PROPERTIES
    
    var filteredCompleteBooks: [ReadingBook] {
        readingBooks.getFilteredReadingBooks(
            .complete,
            searchQuery: searchQuery, bookSortType: selectedSortType
        )
    }
    
    var filteredFavoriteBooks: [FavoriteBook] {
        favoriteBooks.getFilteredFavoriteBooks(
            searchQuery: searchQuery,
            bookSortType: selectedSortType
        )
    }
    
    // MARK: - PROPERTIES
    
    let coulmns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var searchQuery: String
    @Binding var selectedSortType: BookSortCriteria
    let viewType: BookShelfListViewType
    
    // MARK: - INITIALIZER
    
    init(searchQuery: Binding<String>, selectedSortType: Binding<BookSortCriteria>,
         viewType: BookShelfListViewType) {
        self._searchQuery = searchQuery
        self._selectedSortType = selectedSortType
        self.viewType = viewType
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookShelfList
    }
}

// MARK: - EXTENSIONS

extension BookShelfListScrollView {
    var bookShelfList: some View {
        Group {
            switch viewType {
            case .complete:
                if filteredCompleteBooks.isEmpty {
                    noResultLabel
                } else {
                    scrollBooks
                }
            case .favorite:
                if filteredFavoriteBooks.isEmpty {
                    noResultLabel
                } else {
                    scrollBooks
                }
            }
        }
    }
    
    var scrollBooks: some View {
        ScrollView {
            LazyVGrid(columns: coulmns, spacing: 15) {
                switch viewType {
                case .favorite:
                    ForEach(filteredFavoriteBooks) { favoriteBook in
                        FavoriteBookCellButton(favoriteBook, viewType: .navigation)
                    }
                case .complete:
                    ForEach(filteredCompleteBooks, id: \.self) { completeBook in
                        ReadingBookButton(completeBook, buttonType: .shelf)
                    }
                }
            }
            .padding(10)
            .id("Scroll_To_Top")
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
            selectedSortType: .constant(.titleAscendingOrder),
            viewType: .favorite
        )
        .environmentObject(RealmManager())
    }
}
