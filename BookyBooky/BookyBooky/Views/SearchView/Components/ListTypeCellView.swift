//
//  ListTypeCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI
import Shimmer

struct ListTypeCellView: View {
    
    // MARK: - COSTANT PROPERTIES
    
    let COVER_WIDTH: CGFloat = 150  // 표지(커버) 이미지 너비
    let COVER_HEIGHT: CGFloat = 200 // 표지(커버) 이미지 높이
    
    // MARK: - PROPERTIES
    
    let bookItem: BookList.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isLoading = true
    @State private var isPresentingBookInfoView = false
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            asyncImage
            
            VStack {
                title
                
                author
            }
            .redacted(reason: isLoading ? .placeholder : [])
            .shimmering(active: isLoading)
        }
        .onTapGesture {
            isPresentingBookInfoView = true
        }
        .sheet(isPresented: $isPresentingBookInfoView) {
            SearchSheetView(viewType: .search(isbn13: bookItem.isbn13))
        }
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
            case .empty:
                loadingCover
            case .failure(_):
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
            .cornerRadius(10)
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
