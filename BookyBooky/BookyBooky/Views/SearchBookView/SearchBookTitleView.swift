//
//  BookDetailTitleView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import RealmSwift

struct SearchBookTitleView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var isFavoriteBook: Bool = false
    
    // MARK: - PROPERTIES
    
    let bookSearchInfo: detailBookInfo.Item
    @Binding var isLoadingCoverImage: Bool
    
    // MARK: - INTALIZER
    
    init(_ bookSearchInfo: detailBookInfo.Item, isLoadingCoverImage: Binding<Bool>) {
        self.bookSearchInfo = bookSearchInfo
        self._isLoadingCoverImage = isLoadingCoverImage
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookTitleArea
    }
    
    func checkFavoriteBook() {
        for favoriteBook in favoriteBooks where bookSearchInfo.isbn13 == favoriteBook.isbn13 {
            isFavoriteBook = true
            break
        }
    }
}

// MARK: - EXTENSIONS

extension SearchBookTitleView {
    var bookTitleArea: some View {
        HStack {
            bookTitleLabel
            
            Spacer()
            
            addFavoriteBookButton
        }
        .onAppear {
            checkFavoriteBook()
        }
        .frame(height: 60)
        .padding(.top, 5)
        .padding(.bottom, 0)
        .padding(.horizontal)
    }
    
    var bookTitleLabel: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(bookSearchInfo.title.refinedTitle)
                .font(.title)
                .fontWeight(.bold)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            
            Text("\(Text(bookSearchInfo.author.refinedAuthor))・\(Text(bookSearchInfo.publisher))")
                .font(.headline)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .redacted(reason: isLoadingCoverImage ? .placeholder : [])
        .shimmering(active: isLoadingCoverImage)
    }
    
    var addFavoriteBookButton: some View {
        Button {
            isFavoriteBook.toggle()
            
            if isFavoriteBook {
                let favoriteBook = FavoriteBook(
                    value: [
                        "title": "\(bookSearchInfo.title.refinedTitle)",
                        "author": "\(bookSearchInfo.author.refinedAuthor)",
                        "cover": "\(bookSearchInfo.cover)",
                        "salesPoint": "\(bookSearchInfo.salesPoint)",
                        "isbn13": "\(bookSearchInfo.isbn13)"
                    ]
                )
                realmManager.addFavoriteBook(favoriteBook)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    realmManager.deleteFavoriteBook(bookSearchInfo.isbn13)
                }
            }
            HapticManager.shared.impact(.rigid)
        } label: {
            if isFavoriteBook {
                Image(systemName: "heart.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(bookSearchInfo.bookCategory.accentColor)
                    .clipShape(Circle())
            } else {
                Image(systemName: "heart.fill")
                    .foregroundColor(bookSearchInfo.categoryName.refinedCategory.accentColor)
                    .padding()
                    .background {
                        Circle()
                            .stroke(bookSearchInfo.categoryName.refinedCategory.accentColor, lineWidth: 1.8)
                    }
            }
        }
        .disabled(isLoadingCoverImage)
    }
}

// MARK: - PREVIEW

struct SearchInfoTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookTitleView(
            detailBookInfo.Item.preview,
            isLoadingCoverImage: .constant(false)
        )
        .environmentObject(RealmManager())
        .previewLayout(.sizeThatFits)
    }
}
