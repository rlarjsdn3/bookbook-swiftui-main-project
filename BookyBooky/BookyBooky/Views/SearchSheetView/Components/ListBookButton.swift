//
//  SearchSheetCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/01.
//

import SwiftUI
import RealmSwift

struct ListBookButton: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(ReadingBook.self) var readingBooks
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var isLoadingCoverImage = true
    @State private var isPresentingSearchBookView = false
    
    // MARK: - PROPERTIES
    
    let book: briefBookInfo.Item
    
    // MARK: - INTIALIZER
    
    init(_ book: briefBookInfo.Item) {
        self.book = book
    }
    
    // MARK: - BODY
    
    var body: some View {
        listBookButton
            .onTapGesture {
                hideKeyboard()
                isPresentingSearchBookView = true
            }
            .navigationDestination(isPresented: $isPresentingSearchBookView) {
                SearchBookView(book.isbn13, type: .navigationStack)
                
            }
    }
    
    func checkReadingBook() -> Bool {
        for readingBook in readingBooks where book.isbn13 == readingBook.isbn13 {
            return true
        }
        return false
    }
    
    func checkFavoriteBook() -> Bool {
        for favoriteBook in favoriteBooks where book.isbn13 == favoriteBook.isbn13 {
            return true
        }
        return false
    }
}

// MARK: - EXTENSIONS

extension ListBookButton {
    var listBookButton: some View {
        ZStack {
            bookCoverImage
            
            bookInfoLabel
        }
        .padding(.top, 18)
    }
    
    var bookCoverImage: some View {
        HStack {
            asyncCoverImage(
                book.cover,
                width: mainScreen.width * 0.32, height: 190,
                coverShape: RoundedRectTRBR()
            )
            .onAppear {
                isLoadingCoverImage = false
            }
            
            Spacer()
        }
    }
    
    var bookInfoLabel: some View  {
        HStack {
            Spacer()
            
            ZStack {
                RoundedRectTLBL()
                    .fill(book.categoryName.refinedCategory.themeColor)
                    .offset(y: 4)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: -5, y: 5)
                
                RoundedRectTLBL()
                    .fill(.white)
                    .offset(y: -4)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 5, y: 5)
                
                
                VStack( alignment: .leading, spacing: 2) {
                    bookTitleText
                    
                    bookSubInfoLabel
                }
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .bottomTrailing) {
                    HStack {
                        if checkReadingBook() {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 21))
                                .foregroundColor(Color(uiColor: .darkGray))
                        }
                        
                        if checkFavoriteBook() {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundColor(.pink)
                        }
                    }
                }
                .redacted(reason: isLoadingCoverImage ? .placeholder : [])
                .shimmering(active: isLoadingCoverImage)
                .padding()
            }
            .frame(
                width: mainScreen.width * 0.71,
                height: 130
            )
        }
    }
}

extension ListBookButton {
    var bookTitleText: some View {
        Text(book.title.refinedTitle)
            .font(.title3)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .padding(.bottom, 2)
    }
    
    var bookSubInfoLabel: some View {
        VStack (alignment: .leading) {
            bookAuthorText
            
            bookPublisherText
            
            Spacer()
            
            bookPubDateText
        }
        .foregroundColor(.secondary)
    }
    
    var bookAuthorText: some View {
        Text(book.author.refinedAuthor)
            .foregroundColor(.primary)
            .fontWeight(.bold)
    }
    
    var bookPublisherText: some View {
        HStack(spacing: 2) {
            Text(book.publisher)
            
            Text("・")
            
            Text(book.bookCategory.rawValue)
        }
        .fontWeight(.semibold)
    }
    
    var bookPubDateText: some View {
        Text("\(book.pubDate.refinedPublishDate.standardDateFormat)")
    }
}

// MARK: - PREVIEW

struct SearchBookCellButton_Previews: PreviewProvider {
    static var previews: some View {
        ListBookButton(briefBookInfo.Item.preview)
            .previewLayout(.sizeThatFits)
    }
}
