//
//  ListTypeCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI
import Shimmer

struct ListTypeCellView: View {
    @State private var isLoading = true
    
    let bookItem: BookList.Item
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: bookItem.cover)) { phase in
                switch phase {
                case .empty:
                    loadingImage
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 200)
                        .cornerRadius(10)
                        .onAppear {
                            isLoading = false
                        }
                case .failure(_):
                    loadingImage
                @unknown default:
                    loadingImage
                }
            }
            
            Text(bookItem.originalTitle)
                .font(.headline)
                .fontWeight(.bold)
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
            
            Text(bookItem.authorInfo)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
        }
    }
}

extension ListTypeCellView {
    var loadingImage: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.white)
            .foregroundColor(.gray)
            .frame(width: 150, height: 200)
            .shimmering(active: isLoading)
    }
}

struct ListTypeCellView_Previews: PreviewProvider {
    static var previews: some View {
        ListTypeCellView(bookItem: BookList.preview.item[0])
    }
}
