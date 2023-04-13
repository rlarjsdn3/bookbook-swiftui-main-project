//
//  FavoriteBookCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI
import RealmSwift

struct FavoriteBookCellView: View {
    
    // MARK: - CONSTANT PROPERTIES
    
    let COVER_WIDTH: CGFloat = 150
    let COVER_HEIGHT: CGFloat = 200
    
    // MARK: - PROPERTIES
    
    let favoriteBook: FavoriteBook
    let viewType: FavoriteBookCellViewType
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isLoading = true
    @State private var isPresentingFavoriteBookInfoSheet = false
    @State private var isPresentingFavoriteBookInfoStack = false
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            VStack {
                asyncImage(favoriteBook.title)
                
                bookTitle
                
                bookAuthor
            }
            .onTapGesture {
                switch viewType {
                case .sheet:
                    isPresentingFavoriteBookInfoSheet = true
                case .navigationStack:
                    isPresentingFavoriteBookInfoStack = true
                }
            }
            .sheet(isPresented: $isPresentingFavoriteBookInfoSheet) {
                SearchInfoView(isbn13: favoriteBook.isbn13, isPresentingBackButton: false)
            }
            .navigationDestination(isPresented: $isPresentingFavoriteBookInfoStack) {
                SearchInfoView(isbn13: favoriteBook.isbn13, isPresentingBackButton: true)
                
            }
            .padding(.vertical, 10)
        }
    }
}

// MARK: - EXTENSIONS

extension FavoriteBookCellView {
    func asyncImage(_ url: String) -> some View {
        AsyncImage(
            url: URL(string: favoriteBook.cover),
            transaction: Transaction(animation: .default)
        ) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: COVER_WIDTH,
                        height: COVER_HEIGHT
                    )
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: -5, y: 5)
                    .onAppear {
                        isLoading = false
                    }
            case .failure(_):
                loadingCover
            case .empty:
                loadingCover
            @unknown default:
                loadingCover
            }
        }
    }
    
    var loadingCover: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.gray.opacity(0.1))
            .frame(
                width: COVER_WIDTH,
                height: COVER_HEIGHT
            )
            .shimmering(active: isLoading)
    }
    
    var bookTitle: some View {
        Text(favoriteBook.title)
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: COVER_WIDTH, height: 25)
            .padding(.horizontal)
            .padding(.bottom, -5)
            .redacted(reason: isLoading ? .placeholder : [])
            .shimmering(active: isLoading)
    }
    
    var bookAuthor: some View {
        Text(favoriteBook.author)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
            .frame(width: COVER_WIDTH)
            .redacted(reason: isLoading ? .placeholder : [])
            .shimmering(active: isLoading)
    }
}

// MARK: - PREVIEW

struct FavoriteBookCellView_Previews: PreviewProvider {
    @ObservedResults(FavoriteBook.self) static var favoriteBooks
    
    static var previews: some View {
        FavoriteBookCellView(favoriteBook: favoriteBooks[0], viewType: .sheet)
    }
}
