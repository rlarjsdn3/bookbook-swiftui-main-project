//
//  BookDetailTitleView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import RealmSwift

struct SearchInfoTitleView: View {
    
    // MARK: - PROPERTIES
    
    let bookInfo: BookInfo.Item
    @Binding var isLoading: Bool
    @Binding var isPresentingFavoriteAlert: Bool
    
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var isFavorite: Bool = false
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            title
            
            Spacer()
            
            favoriteButton
        }
        .frame(height: 60)
        .padding(.top, 5)
        .padding(.bottom, 0)
        .padding(.horizontal)
        .onAppear {
            for favoriteBook in favoriteBooks where bookInfo.isbn13 == favoriteBook.isbn13 {
                isFavorite = true
                break
            }
        }
    }
}

// MARK: - EXTENSIONS

extension SearchInfoTitleView {
    var title: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(bookInfo.title.refinedTitle)
                .font(.title)
                .fontWeight(.bold)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
            
            HStack(spacing: 2) {
                Text(bookInfo.author.refinedAuthor)
               
                Text("・")
                
                Text(bookInfo.publisher)
            }
            .font(.headline)
            .foregroundColor(.secondary)
            .redacted(reason: isLoading ? .placeholder : [])
            .shimmering(active: isLoading)
        }
    }
    
    var favoriteButton: some View {
        // '좋아요' 버튼은 미완성입니다. (디자인, 기능 등)
        Button {
            isFavorite.toggle()
            
            if isFavorite {
                let favorite = FavoriteBook(
                    value: [
                        "title": "\(bookInfo.title.refinedTitle)",
                        "author": "\(bookInfo.author.refinedAuthor)",
                        "isbn13": "\(bookInfo.isbn13)"
                    ]
                )
                RealmManager.shared.addFavoriteBook(favorite)
                
                isPresentingFavoriteAlert = true
            } else {
                RealmManager.shared.deleteFavoriteBook(bookInfo.isbn13)
            }
        } label: {
            if isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(bookInfo.categoryName.refinedCategory.accentColor) // 카테고리별 강조 색상으로
                    .clipShape(Circle())
            } else {
                Image(systemName: "heart.fill")
                    .foregroundColor(bookInfo.categoryName.refinedCategory.accentColor)
                    .padding()
                    .background {
                        Circle()
                            .stroke(bookInfo.categoryName.refinedCategory.accentColor, lineWidth: 2)
                    }
            }
        }
        .disabled(isLoading)
    }
}

// MARK: - PREVIEW

struct SearchInfoTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfoTitleView(
            bookInfo: BookInfo.Item.preview[0],
            isLoading: .constant(false),
            isPresentingFavoriteAlert: .constant(false)
        )
    }
}
