//
//  ListTypeCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI
import Shimmer
import RealmSwift

struct ListTypeCellView: View {
    
    // MARK: - COSTANT PROPERTIES
    
    let COVER_WIDTH: CGFloat = 150  // 표지(커버) 이미지 너비
    let COVER_HEIGHT: CGFloat = 200 // 표지(커버) 이미지 높이
    
    // MARK: - PROPERTIES
    
    let bookItem: BookList.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var isLoading = true
    @State private var isPresentingBookInfoView = false
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            asyncImage
            
            VStack {
                title
                
                HStack {
                    // 현재 읽고 있는 중이면 아이콘 출력하기 (미완성)
                    Image(systemName: "heart.fill")
                        .font(.title3)
                        .padding(.leading)
                        .hidden()
                    
                    Spacer(minLength: 0)
                    
                    author
                    
                    Spacer(minLength: 0)
                    
                    if isFavoriteBook() {
                        Image(systemName: "heart.fill")
                            .font(.title3)
                            .foregroundColor(.pink)
                            .padding(.trailing)
                    } else {
                        Image(systemName: "heart.fill")
                            .font(.title3)
                            .padding(.leading)
                            .hidden()
                    }
                }
            }
            .redacted(reason: isLoading ? .placeholder : [])
            .shimmering(active: isLoading)
        }
        .onTapGesture {
            isPresentingBookInfoView = true
        }
        .sheet(isPresented: $isPresentingBookInfoView) {
            SearchInfoView(isbn13: bookItem.isbn13, isPresentingBackButton: false)
        }
    }
    
    func isFavoriteBook() -> Bool {
        for favoriteBook in favoriteBooks where bookItem.isbn13 == favoriteBook.isbn13 {
            return true
        }
        return false
    }
}

// MARK: - EXTENSIONS

extension ListTypeCellView {
    var asyncImage: some View {
        AsyncImage(url: URL(string: bookItem.cover),
                   transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                cover(image)
            case .failure(_), .empty:
                loadingImage
            @unknown default:
                loadingImage
                
            }
        }
    }
    
    var loadingImage: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.gray.opacity(0.1))
            .frame(
                width: COVER_WIDTH,
                height: COVER_HEIGHT
            )
            .shimmering(active: isLoading)
    }
    
    var title: some View {
        Text(bookItem.title.refinedTitle)
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(height: 25)
            .padding(.horizontal)
            .padding(.bottom, -5)
    }
    
    var author: some View {
        Text(bookItem.author.refinedAuthor)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
    }
}

extension ListTypeCellView {
    @ViewBuilder
    func cover(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(
                width: COVER_WIDTH,
                height: COVER_HEIGHT
            )
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 8, x: -5, y: 5)
            .onAppear {
                isLoading = false
            }
    }
}

// MARK: - RREVIEW

struct ListTypeCellView_Previews: PreviewProvider {
    static var previews: some View {
        ListTypeCellView(bookItem: BookList.Item.preview[0])
    }
}
