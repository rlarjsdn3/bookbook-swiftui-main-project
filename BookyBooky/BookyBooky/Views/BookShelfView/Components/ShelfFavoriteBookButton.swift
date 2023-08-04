//
//  FavoriteBookCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI
import RealmSwift

struct ShelfFavoriteBookButton: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isLoadingCoverImage = true
    @State private var isPresentingSearchBookViewFromSheet = false
    @State private var isPresentingSearchBookViewFromNavigation = false
    
    // MARK: - PROPERTIES
    
    let favoriteBook: FavoriteBook
    let type: ButtonType.ShelfFavBookButton
    
    // MARK: - INTIALIZER
    
    init(_ favoriteBook: FavoriteBook, type: ButtonType.ShelfFavBookButton) {
        self.favoriteBook = favoriteBook
        self.type = type
    }
    
    // MARK: - BODY
    
    var body: some View {
        favoriteBookButton
            .sheet(isPresented: $isPresentingSearchBookViewFromSheet) {
                SearchBookView(favoriteBook.isbn13, in: .sheet)
            }
            .navigationDestination(isPresented: $isPresentingSearchBookViewFromNavigation) {
                SearchBookView(favoriteBook.isbn13, in: .navigation)
            }
    }
}

// MARK: - EXTENSIONS

extension ShelfFavoriteBookButton {
    var favoriteBookButton: some View {
        VStack {
            asyncCoverImage(favoriteBook.cover)
                .onAppear {
                    isLoadingCoverImage = false
                }
            
            bookInfoLabel
        }
        .onTapGesture {
            switch type {
            case .sheet:
                isPresentingSearchBookViewFromSheet = true
            case .navigation:
                isPresentingSearchBookViewFromNavigation = true
            }
        }
    }
    
    var bookInfoLabel: some View {
        VStack {
            bookTitleText
            
            bookAuthorText
        }
    }
    
    var bookTitleText: some View {
        Text(favoriteBook.title)
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: 150, height: 25)
            .padding(.horizontal)
            .padding(.bottom, -5)
            .redacted(reason: isLoadingCoverImage ? .placeholder : [])
            .shimmering(active: isLoadingCoverImage)
    }
    
    var bookAuthorText: some View {
        Text(favoriteBook.author)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
            .frame(width: 150)
            .redacted(reason: isLoadingCoverImage ? .placeholder : [])
            .shimmering(active: isLoadingCoverImage)
    }
}

// MARK: - PREVIEW

struct FavoriteBookCellView_Previews: PreviewProvider {
    static var previews: some View {
        ShelfFavoriteBookButton(FavoriteBook.preview, type: .sheet)
    }
}
