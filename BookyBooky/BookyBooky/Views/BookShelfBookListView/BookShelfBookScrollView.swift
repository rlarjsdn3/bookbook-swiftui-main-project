//
//  FavoriteBooksScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/10.
//

import SwiftUI
import RealmSwift

struct BookShelfBookScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmMananger: RealmManager
    
    @ObservedResults(CompleteBook.self) var readingBooks
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    // MARK: - COMPUTED PROPERTIES
    
    var filteredCompBooks: [CompleteBook] {
        readingBooks.getFilteredReadingBooks(
            .complete,
            searchQuery: searchQuery, bookSortType: selectedSortType
        )
    }
    
    var filteredFavBooks: [FavoriteBook] {
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
    let type: BookShelfList
    
    // MARK: - INITIALIZER
    
    init(searchQuery: Binding<String>,
         selectedSortType: Binding<BookSortCriteria>,
         type: BookShelfList) {
        self._searchQuery = searchQuery
        self._selectedSortType = selectedSortType
        self.type = type
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookScrollContent
    }
}

// MARK: - EXTENSIONS

extension BookShelfBookScrollView {
    var bookScrollContent: some View {
        Group {
            switch type {
            case .complete:
                if filteredCompBooks.isEmpty {
                    noResultLabel
                } else {
                    bookButtonGroup
                }
            case .favorite:
                if filteredFavBooks.isEmpty {
                    noResultLabel
                } else {
                    bookButtonGroup
                }
            }
        }
    }
    
    var bookButtonGroup: some View {
        ScrollView {
            LazyVGrid(columns: coulmns, spacing: 15) {
                switch type {
                case .favorite:
                    ForEach(filteredFavBooks) { favoriteBook in
                        FavBookButton(favoriteBook, type: .navigation)
                    }
                case .complete:
                    ForEach(filteredCompBooks, id: \.self) { completeBook in
                        CompleteBookButton(completeBook, type: .shelf)
                    }
                }
            }
            .padding(10)
            .id("Scroll_To_Top")
        }
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

struct FavoriteBooksScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfBookScrollView(
            searchQuery: .constant(""),
            selectedSortType: .constant(.titleAscendingOrder),
            type: .favorite
        )
        .environmentObject(RealmManager())
    }
}
