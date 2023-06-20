//
//  FavoriteBookCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI
import RealmSwift

struct ShelfFavBookButton: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isLoadingCoverImage = true
    @State private var isPresentingSearchBookViewFromSheet = false
    @State private var isPresentingSearchBookViewFromNavigation = false
    
    // MARK: - PROPERTIES
    
    let favBook: FavoriteBook
    let type: ButtonType.ShelfFavBookButton
    
    // MARK: - INTIALIZER
    
    init(_ favBook: FavoriteBook, type: ButtonType.ShelfFavBookButton) {
        self.favBook = favBook
        self.type = type
    }
    
    // MARK: - BODY
    
    var body: some View {
        favBookButton
            .sheet(isPresented: $isPresentingSearchBookViewFromSheet) {
                SearchBookView(favBook.isbn13, type: .sheet)
            }
            .navigationDestination(isPresented: $isPresentingSearchBookViewFromNavigation) {
                SearchBookView(favBook.isbn13, type: .navigation)
            }
    }
}

// MARK: - EXTENSIONS

extension ShelfFavBookButton {
    var favBookButton: some View {
        VStack {
            asyncCoverImage(
                favBook.cover,
                width: 150, height: 200
            )
            .onAppear {
                isLoadingCoverImage = false
            }
            
            InfoLabel
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
    
    var InfoLabel: some View {
        VStack {
            bookTitleText
            
            bookAuthorText
        }
    }
    
    var bookTitleText: some View {
        Text(favBook.title)
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
        Text(favBook.author)
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
        ShelfFavBookButton(FavoriteBook.preview, type: .sheet)
    }
}
