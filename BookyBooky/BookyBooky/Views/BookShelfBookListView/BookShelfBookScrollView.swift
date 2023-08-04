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
    @EnvironmentObject var bookShelfBookListViewData: BookShelfBookListViewData
    
    @ObservedResults(CompleteBook.self) var compBooks
    @ObservedResults(FavoriteBook.self) var favBooks
    
    // MARK: - COMPUTED PROPERTIES
    
    var filteredCompBooks: [CompleteBook] {
        compBooks.getFilteredReadingBooks(
            .complete,
            searchQuery: bookShelfBookListViewData.searchQuery, bookSortType: bookShelfBookListViewData.selectedSort
        )
    }
    
    var filteredFavBooks: [FavoriteBook] {
        favBooks.getFilteredFavoriteBooks(
            searchQuery: bookShelfBookListViewData.searchQuery,
            bookSortType: bookShelfBookListViewData.selectedSort
        )
    }
    
    // MARK: - PROPERTIES
    
    let coulmns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let type: ListType.BookShelfList
    
    // MARK: - INITIALIZER
    
    init(type: ListType.BookShelfList) {
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
                        ShelfFavBookButton(favoriteBook, type: .navigation)
                    }
                case .complete:
                    ForEach(filteredCompBooks, id: \.self) { completeBook in
                        HomeReadingBookButton(completeBook)
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
        BookShelfBookScrollView(type: .favorite)
            .environmentObject(RealmManager())
            .environmentObject(BookShelfBookListViewData())
    }
}
