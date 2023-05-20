//
//  ListTypeCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI
import RealmSwift

struct SearchCellButton: View {
    
    // MARK: - PROPERTIES
    
    let listOfBookItem: BookList.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(ReadingBook.self) var readingBooks
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var isPresentingBookInfoView = false
    
    // MARK: - INTIALIZER
    
    init(_ listOfBookItem: BookList.Item) {
        self.listOfBookItem = listOfBookItem
    }
    
    // MARK: - BODY
    
    var body: some View {
        searchCellButton
            .onTapGesture {
                isPresentingBookInfoView = true
            }
            .sheet(isPresented: $isPresentingBookInfoView) {
                SearchInfoView(isbn13: listOfBookItem.isbn13, isPresentingBackButton: false)
            }
    }
    
    func isFavoriteBook() -> Bool {
        for favoriteBook in favoriteBooks where listOfBookItem.isbn13 == favoriteBook.isbn13 {
            return true
        }
        return false
    }
    
    func isReadingBook() -> Bool {
        for targetBook in readingBooks where listOfBookItem.isbn13 == targetBook.isbn13 {
            return true
        }
        return false
    }
}

// MARK: - EXTENSIONS

extension SearchCellButton {
    var searchCellButton: some View {
        VStack {
            asyncCoverImage(
                listOfBookItem.cover,
                width: 150, height: 200,
                coverShape: RoundedCoverShape()
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
                            if isReadingBook() {
                                Image(systemName: "book.closed.fill")
                                    .foregroundColor(Color(uiColor: .darkGray))
                            }
                            
                            Spacer()
                            
                            if isFavoriteBook() {
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
        Text(listOfBookItem.title.refinedTitle)
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(height: 25)
            .padding(.horizontal)
            .padding(.bottom, -5)
    }
    
    var bookAuthorText: some View {
        Text(listOfBookItem.author.refinedAuthor)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: 100)
    }
}


// MARK: - RREVIEW

struct SearchCellButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchCellButton(BookList.Item.preview[0])
    }
}
