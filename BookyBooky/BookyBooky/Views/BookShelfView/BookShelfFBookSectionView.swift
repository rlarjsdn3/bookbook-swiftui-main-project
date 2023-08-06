//
//  BookShelfFavBookTabView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/17/23.
//

import SwiftUI
import RealmSwift

struct BookShelfFBookSectionView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var isPresentingFavoriteBookListView = false
    
    // MARK: - BODY
    
    var body: some View {
        Section {
            if favoriteBooks.isEmpty {
                noBooksLabel
            } else {
                scrollContent
            }
        } header: {
            tabTitle
        }
        .sheet(isPresented: $isPresentingFavoriteBookListView) {
            BookShelfListView(type: .favorite)
        }
    }
}

// MARK: - EXTENSIONS

extension BookShelfFBookSectionView {
    var scrollContent: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                let recent10FavBooks = favoriteBooks.reversed().prefix(min(10, favoriteBooks.count))
                
                ForEach(recent10FavBooks) { book in
                    ShelfFavoriteBookButton(book, type: .sheet)
                }
            }
            .padding(.top, 26)
        }
        .padding([.leading, .bottom, .trailing])
    }
    
    var noBooksLabel: some View {
        VStack(spacing: 5) {
            Text("찜한 도서가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("도서를 찜해보세요.")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 50)
    }
    
    var tabTitle: some View {
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

struct BookShelfFBookSectionView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfFBookSectionView()
    }
}
