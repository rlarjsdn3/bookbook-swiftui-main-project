//
//  ListTypeCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI
import RealmSwift

struct BookListButton: View {
    
    // MARK: - PROPERTIES
    
    let book: SimpleBookInfo.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(CompleteBook.self) var readingBooks
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var isPresentingBookInfoView = false
    
    // MARK: - COMPUTED PROPERTIES
    
    var isFavoriteBook: Bool {
        for fBook in favoriteBooks where book.isbn13 == fBook.isbn13 {
            return true
        }
        return false
    }
    
    var isReadingBook: Bool {
        for rBook in readingBooks where book.isbn13 == rBook.isbn13 {
            return true
        }
        return false
    }
    
    // MARK: - INTIALIZER
    
    init(_ book: SimpleBookInfo.Item) {
        self.book = book
    }
    
    // MARK: - BODY
    
    var body: some View {
        searchCellButton
            .onTapGesture {
                isPresentingBookInfoView = true
            }
            .sheet(isPresented: $isPresentingBookInfoView) {
                SearchBookView(book.isbn13, in: .sheet)
            }
    }
}

// MARK: - EXTENSIONS

extension BookListButton {
    var searchCellButton: some View {
        VStack {
            asyncCoverImage(
                book.cover,
                coverShape: RoundedRect(byRoundingCorners: [.allCorners])
            )
            
            bookInfoLabel
        }
    }
    
    var bookInfoLabel: some View {
        VStack {
            bookTitleText
                
            bookAuthorText
                .overlay {
                    HStack {
                        Group {
                            if isReadingBook {
                                Image(systemName: "book.closed.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(uiColor: .darkGray))
                            }
                            
                            Spacer()
                            
                            if isFavoriteBook {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.pink)
                            }
                        }
                        .font(.title3)
                    }
                    .frame(width: 150)
                }
        }
    }
    
    var bookTitleText: some View {
        Text(book.title.refinedTitle)
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(height: 25)
            .padding(.horizontal)
            .padding(.bottom, -5)
    }
    
    var bookAuthorText: some View {
        Text(book.author.refinedAuthor)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: 100)
    }
}


// MARK: - RREVIEW

struct BookListButton_Previews: PreviewProvider {
    static var previews: some View {
        BookListButton(SimpleBookInfo.Item.preview)
    }
}
