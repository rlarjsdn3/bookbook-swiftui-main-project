//
//  FavoriteBookCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI
import RealmSwift

struct FavoriteBookCellButton: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isLoadingCoverImage = true
    @State private var isPresentingSearchBookViewFromSheet = false
    @State private var isPresentingSearchBookViewFromNavigation = false
    
    // MARK: - PROPERTIES
    
    let favoriteBook: FavoriteBook
    let viewType: SearchBookViewType
    
    // MARK: - INTIALIZER
    
    init(_ favoriteBook: FavoriteBook, viewType: SearchBookViewType) {
        self.favoriteBook = favoriteBook
        self.viewType = viewType
    }
    
    
    // MARK: - BODY
    
    var body: some View {
        favoriteBookCellButton
            .sheet(isPresented: $isPresentingSearchBookViewFromSheet) {
                SearchBookView(favoriteBook.isbn13, type: .sheet)
            }
            .navigationDestination(isPresented: $isPresentingSearchBookViewFromNavigation) {
                SearchBookView(favoriteBook.isbn13, type: .navigationStack)
            }
    }
}

// MARK: - EXTENSIONS

extension FavoriteBookCellButton {
    var favoriteBookCellButton: some View {
        VStack {
            asyncCoverImage(
                favoriteBook.cover,
                width: 150, height: 200
            )
            .onAppear {
                isLoadingCoverImage = false
            }
            
            favoriteBookInfoLabel
        }
        .onTapGesture {
            switch viewType {
            case .sheet:
                isPresentingSearchBookViewFromSheet = true
            case .navigation:
                isPresentingSearchBookViewFromNavigation = true
            }
        }
    }
    
    var favoriteBookInfoLabel: some View {
        VStack {
            favoriteBookTitleText
            
            favoriteBookAuthorText
        }
    }
    
    var favoriteBookTitleText: some View {
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
    
    var favoriteBookAuthorText: some View {
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
        FavoriteBookCellButton(FavoriteBook.preview, viewType: .sheet)
    }
}
