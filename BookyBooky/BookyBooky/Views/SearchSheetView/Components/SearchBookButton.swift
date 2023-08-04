//
//  SearchSheetCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/01.
//

import SwiftUI
import RealmSwift

struct SearchBookButton: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(CompleteBook.self) var compBooks
    @ObservedResults(FavoriteBook.self) var favBooks
    
    @State private var isLoadingCoverImage = true
    @State private var isPresentingSearchBookView = false
    
    // MARK: - PROPERTIES
    
    let book: SimpleBookInfo.Item
    let mode: ListMode
    
    // MARK: - INTIALIZER
    
    init(_ book: SimpleBookInfo.Item, mode: ListMode) {
        self.book = book
        self.mode = mode
    }
    
    // MARK: - BODY
    
    var body: some View {
        Group {
            switch mode {
            case .grid:
                gridBookButton
            case .list:
                listBookButton
            }
        }
        .onTapGesture {
            hideKeyboard()
            isPresentingSearchBookView = true
        }
        .navigationDestination(isPresented: $isPresentingSearchBookView) {
            SearchBookView(book.isbn13, type: .navigation)
        }
    }
    
    func isCompBook() -> Bool {
        for readingBook in compBooks where book.isbn13 == readingBook.isbn13 {
            return true
        }
        return false
    }
    
    func isFavBook() -> Bool {
        for favoriteBook in favBooks where book.isbn13 == favoriteBook.isbn13 {
            return true
        }
        return false
    }
}

// MARK: - EXTENSIONS

extension SearchBookButton {
    var listBookButton: some View {
        ZStack {
            bookCoverImage
            
            bookInfoLabel
        }
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
                RoundedRect(byRoundingCorners: [.topLeft, .bottomLeft])
                    .fill(book.categoryName.refinedCategory.themeColor)
                    .offset(y: 4)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: -5, y: 5)
                
                RoundedRect(byRoundingCorners: [.topLeft, .bottomLeft])
                    .fill(.white)
                    .offset(y: -4)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 5, y: 5)
                
                
                VStack( alignment: .leading, spacing: 2) {
                    bookTitleText
                    
                    subInfoLabel
                }
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .bottomTrailing) {
                    HStack {
                        if isCompBook() {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color(uiColor: .darkGray))
                        }
                        
                        if isFavBook() {
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
    
    var bookTitleText: some View {
        Group {
            switch mode {
            case .grid:
                Text(book.bookTitle)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(height: 25)
                    .padding(.horizontal)
                    .padding(.bottom, -5)
            case .list:
                Text(book.bookTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding(.bottom, 2)
            }
        }
    }
    
    var subInfoLabel: some View {
        VStack (alignment: .leading) {
            bookAuthorText
            
            bookPublisherText
            
            Spacer()
            
            bookPubDateText
        }
        .foregroundColor(.secondary)
    }
    
    var bookAuthorText: some View {
        Group {
            switch mode {
            case .grid:
                Text(book.bookAuthor)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(width: 100)
                
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
            case .list:
                Text(book.bookAuthor)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                
            }
        }
    }
    
    var bookPublisherText: some View {
        Text("\(book.publisher) ・ \(book.bookCategory.name)")
            .fontWeight(.semibold)
    }
    
    var bookPubDateText: some View {
        Text("\(book.pubDate.refinedPublishDate.standardDateFormat)")
    }
}

extension SearchBookButton {
    var gridBookButton: some View {
        VStack {
            asyncCoverImage(book.cover)
            
            bookTitleText
            
            bookAuthorText
        }
    }
}

// MARK: - PREVIEW

struct SearchBookCellButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookButton(SimpleBookInfo.Item.preview, mode: .list)
    }
}
