//
//  BookDetailTitleView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import RealmSwift

struct SearchBookMainInfoView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    @EnvironmentObject var searchBookViewData: SearchBookViewData
    
    @ObservedResults(FavoriteBook.self) var favBooks
    
    @State private var isFavorite: Bool = false
    
    // MARK: - PROPERTIES
    
    let bookItem: detailBookItem.Item
    
    // MARK: - INTALIZER
    
    init(_ bookItem: detailBookItem.Item) {
        self.bookItem = bookItem
    }
    
    // MARK: - BODY
    
    var body: some View {
        mainInfo
    }
    
    // MARK: - FUNCTIONS
    
    func isFavoriteBook() {
        for favBook in favBooks {
            if bookItem.isbn13 == favBook.isbn13 {
                isFavorite = true; break
            }
        }
    }
}

// MARK: - EXTENSIONS

extension SearchBookMainInfoView {
    var mainInfo: some View {
        HStack {
            bookTitleLabel
            
            Spacer()
            
            addFavoriteBookButton
        }
        .onAppear {
            isFavoriteBook()
        }
        .frame(height: 60)
        .padding(.top, 5)
        .padding(.bottom, 0)
        .padding(.horizontal)
    }
    
    var bookTitleLabel: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(bookItem.bookTitle)
                .font(.title)
                .fontWeight(.bold)
            
            Text("\(Text(bookItem.bookAuthor)) ・ \(Text(bookItem.publisher))")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .minimumScaleFactor(0.8)
        .lineLimit(1)
        .redacted(reason: searchBookViewData.isLoadingCoverImage ? .placeholder : [])
        .shimmering(active: searchBookViewData.isLoadingCoverImage)
    }
    
    var addFavoriteBookButton: some View {
        Button {
            isFavorite.toggle()
            
            if isFavorite {
                let favoriteBook = FavoriteBook(
                    value: [
                        "title": "\(bookItem.title.refinedTitle)",
                        "author": "\(bookItem.author.refinedAuthor)",
                        "cover": "\(bookItem.cover)",
                        "salesPoint": "\(bookItem.salesPoint)",
                        "isbn13": "\(bookItem.isbn13)"
                    ]
                )
                realmManager.addFavoriteBook(favoriteBook)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    realmManager.deleteFavoriteBook(bookItem.isbn13)
                }
            }
            HapticManager.shared.impact(.rigid)
        } label: {
            if isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(bookItem.bookCategory.themeColor, in: .circle)
            } else {
                Image(systemName: "heart.fill")
                    .foregroundColor(bookItem.categoryName.refinedCategory.themeColor)
                    .padding()
                    .background {
                        Circle()
                            .stroke(bookItem.categoryName.refinedCategory.themeColor, lineWidth: 1.8)
                    }
            }
        }
        .disabled(searchBookViewData.isLoadingCoverImage)
    }
}

// MARK: - PREVIEW

struct SearchInfoTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookMainInfoView(detailBookItem.Item.preview)
            .environmentObject(RealmManager())
    }
}
