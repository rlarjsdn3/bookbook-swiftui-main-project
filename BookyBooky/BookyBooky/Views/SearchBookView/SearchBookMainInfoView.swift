//
//  BookDetailTitleView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import Shimmer
import RealmSwift

struct SearchBookMainInfoView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var searchBookViewData: SearchBookViewData
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var isFavorite: Bool = false
    
    // MARK: - PROPERTIES
    
    let haptic = HapticManager()
    
    let book: DetailBookInfo.Item
    
    // MARK: - INTALIZER
    
    init(_ bookItem: DetailBookInfo.Item) {
        self.book = bookItem
    }
    
    // MARK: - BODY
    
    var body: some View {
        mainInfoArea
    }
}

// MARK: - EXTENSIONS

extension SearchBookMainInfoView {
    var mainInfoArea: some View {
        HStack {
            bookTitleLabel
            
            Spacer()
            
            addFavoriteButton
        }
        .onAppear {
            for fBook in favoriteBooks where book.isbn13 == fBook.isbn13 {
                isFavorite = true
                break
            }
        }
        .frame(height: 60)
        .padding(.top, 5)
        .padding(.bottom, 0)
        .padding(.horizontal)
    }
    
    var bookTitleLabel: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(book.bookTitle)
                .font(.title)
                .fontWeight(.bold)
            
            Text("\(Text(book.bookAuthor)) ・ \(Text(book.publisher))")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .minimumScaleFactor(0.8)
        .lineLimit(1)
        .redacted(reason: searchBookViewData.isLoadingCoverImage ? .placeholder : [])
        .shimmering(active: searchBookViewData.isLoadingCoverImage)
    }
    
    var addFavoriteButton: some View {
        Button {
            isFavorite.toggle()
            
            if isFavorite {
                let favoriteBook = FavoriteBook(
                    value: [
                        "title": "\(book.title.refinedTitle)",
                        "author": "\(book.author.refinedAuthor)",
                        "cover": "\(book.cover)",
                        "salesPoint": "\(book.salesPoint)",
                        "isbn13": "\(book.isbn13)"
                    ]
                )
                realmManager.addFavoriteBook(favoriteBook)
                alertManager.isPresentingFavoriteBookAddSuccessToastAlert = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    realmManager.deleteFavoriteBook(book.isbn13)
                }
            }
            haptic.impact(.rigid)
        } label: {
            if isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(book.bookCategory.themeColor, in: .circle)
            } else {
                Image(systemName: "heart.fill")
                    .foregroundColor(book.categoryName.refinedCategory.themeColor)
                    .padding()
                    .background {
                        Circle()
                            .stroke(book.categoryName.refinedCategory.themeColor, lineWidth: 1.8)
                    }
            }
        }
        .disabled(searchBookViewData.isLoadingCoverImage)
    }
}

// MARK: - PREVIEW

#Preview {
    SearchBookMainInfoView(DetailBookInfo.Item.preview)
        .environmentObject(RealmManager())
        .environmentObject(AlertManager())
}
