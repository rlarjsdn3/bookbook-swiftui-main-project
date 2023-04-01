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
    
    let COVER_WIDTH: CGFloat = 150
    let COVER_HEIGHT: CGFloat = 200
    
    // MARK: - PROPERTIES
    
    let bookItem: BookList.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isLoading = true
    
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
            // do seomthing...
        }
    }
}

// MARK: - EXTENSIONS

extension ListTypeCellView {
    var asyncImage: some View {
        AsyncImage(url: URL(string: bookItem.cover)) { image in
            cover(image)
        } placeholder: {
            loadingCover
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
        Text(bookItem.originalTitle)
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(height: 25)
            .padding(.horizontal)
            .padding(.bottom, -5)
    }
    
    var author: some View {
        Text(bookItem.authorInfo)
            .font(.subheadline)
            .foregroundColor(.secondary)
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

struct ListTypeCellView_Previews: PreviewProvider {
    static var previews: some View {
        ListTypeCellView(bookItem: BookList.Item.preview[0])
    }
}
