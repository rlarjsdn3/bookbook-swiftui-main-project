//
//  BookShelfFavBookTabView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/17/23.
//

import SwiftUI
import RealmSwift

struct BookShelfFavBookTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var isPresentingFavoriteBookListView = false
    
    // MARK: - BODY
    
    var body: some View {
        favBookTab
            .sheet(isPresented: $isPresentingFavoriteBookListView) {
                BookShelfListView(type: .favorite)
            }
    }
}

// MARK: - EXTENSIONS

extension BookShelfFavBookTabView {
    var favBookTab: some View {
        Section {
            if favoriteBooks.isEmpty {
                noFavBooksLabel
            } else {
                favBookScrollContent
            }
        } header: {
            favBookHeaderLabel
        }
    }
    
    var favBookScrollContent: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                let recent10FavBooks = favoriteBooks.reversed().prefix(min(10, favoriteBooks.count))
                
                ForEach(recent10FavBooks) { book in
                    ShelfFavBookButton(book, type: .sheet)
                }
            }
            .padding(.top, 26)
        }
        .padding([.leading, .bottom, .trailing])
    }
    
    var noFavBooksLabel: some View {
        VStack(spacing: 5) {
            Text("찜한 도서가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("도서를 찜해보세요.")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 50)
    }
    
    var favBookHeaderLabel: some View {
        HStack {
            Text("찜한 도서")
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                isPresentingFavoriteBookListView = true
            } label: {
                Text("더 보기")
            }
            .disabled(favoriteBooks.isEmpty)

        }
        .padding(.vertical, 10)
        .padding(.bottom, 5)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(.white)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

// MARK: - PREVIEW

#Preview {
    BookShelfFavBookTabView()
}
