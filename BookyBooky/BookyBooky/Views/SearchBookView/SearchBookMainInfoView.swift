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
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var isFavorite: Bool = false
    
    // MARK: - PROPERTIES
    
    let bookInfo: detailBookInfo.Item
    @Binding var isLoadingCoverImage: Bool
    
    // MARK: - INTALIZER
    
    init(_ bookInfo: detailBookInfo.Item, isLoadingCoverImage: Binding<Bool>) {
        self.bookInfo = bookInfo
        self._isLoadingCoverImage = isLoadingCoverImage
    }
    
    // MARK: - BODY
    
    var body: some View {
        mainInfo
    }
    
    // MARK: - FUNCTIONS
    
    func isFavoriteBook() {
        for favoriteBook in favoriteBooks {
            if bookInfo.isbn13 == favoriteBook.isbn13 {
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
            Text(bookInfo.bookTitle)
                .font(.title)
                .fontWeight(.bold)
            
            Text("\(Text(bookInfo.bookAuthor)) ・ \(Text(bookInfo.publisher))")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .minimumScaleFactor(0.8)
        .lineLimit(1)
        .redacted(reason: isLoadingCoverImage ? .placeholder : [])
        .shimmering(active: isLoadingCoverImage)
    }
    
    var addFavoriteBookButton: some View {
        Button {
            isFavorite.toggle()
            
            if isFavorite {
                let favoriteBook = FavoriteBook(
                    value: [
                        "title": "\(bookInfo.title.refinedTitle)",
                        "author": "\(bookInfo.author.refinedAuthor)",
                        "cover": "\(bookInfo.cover)",
                        "salesPoint": "\(bookInfo.salesPoint)",
                        "isbn13": "\(bookInfo.isbn13)"
                    ]
                )
                realmManager.addFavoriteBook(favoriteBook)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    realmManager.deleteFavoriteBook(bookInfo.isbn13)
                }
            }
            HapticManager.shared.impact(.rigid)
        } label: {
            if isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(bookInfo.bookCategory.themeColor, in: .circle)
            } else {
                Image(systemName: "heart.fill")
                    .foregroundColor(bookInfo.categoryName.refinedCategory.themeColor)
                    .padding()
                    .background {
                        Circle()
                            .stroke(bookInfo.categoryName.refinedCategory.themeColor, lineWidth: 1.8)
                    }
            }
        }
        .disabled(isLoadingCoverImage)
    }
}

// MARK: - PREVIEW

struct SearchInfoTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookMainInfoView(
            detailBookInfo.Item.preview,
            isLoadingCoverImage: .constant(false)
        )
        .environmentObject(RealmManager())
        .previewLayout(.sizeThatFits)
    }
}
