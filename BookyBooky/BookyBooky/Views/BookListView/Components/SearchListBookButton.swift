//
//  ListTypeCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI
import RealmSwift

struct SearchListBookButton: View {
    
    // MARK: - PROPERTIES
    
    let bookItem: briefBookInfo.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(CompleteBook.self) var compBooks
    @ObservedResults(FavoriteBook.self) var favBooks
    
    @State private var isPresentingBookInfoView = false
    
    // MARK: - INTIALIZER
    
    init(_ bookItem: briefBookInfo.Item) {
        self.bookItem = bookItem
    }
    
    // MARK: - BODY
    
    var body: some View {
        searchCellButton
            .onTapGesture {
                isPresentingBookInfoView = true
            }
            .sheet(isPresented: $isPresentingBookInfoView) {
                SearchBookView(bookItem.isbn13, type: .sheet)
            }
    }
    
    func isFavBook() -> Bool {
        for favBook in favBooks where bookItem.isbn13 == favBook.isbn13 {
            return true
        }
        return false
    }
    
    func isCompBook() -> Bool {
        for compBook in compBooks where bookItem.isbn13 == compBook.isbn13 {
            return true
        }
        return false
    }
}

// MARK: - EXTENSIONS

extension SearchListBookButton {
    var searchCellButton: some View {
        VStack {
            asyncCoverImage(
                bookItem.cover,
                width: 150, height: 200,
                coverShape: RoundedRect()
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
                            if isCompBook() {
                                Image(systemName: "book.closed.fill")
                                    .foregroundColor(Color(uiColor: .darkGray))
                            }
                            
                            Spacer()
                            
                            if isFavBook() {
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
        Text(bookItem.title.refinedTitle)
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(height: 25)
            .padding(.horizontal)
            .padding(.bottom, -5)
    }
    
    var bookAuthorText: some View {
        Text(bookItem.author.refinedAuthor)
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
        SearchListBookButton(briefBookInfo.Item.preview)
    }
}
