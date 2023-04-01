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
        // 버튼으로 동작하게 코드 구현하기 (BookDetail)
        
        VStack {
            AsyncImage(url: URL(string: bookItem.cover)) { phase in
                switch phase {
                case .empty:
                    loadingImage
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 200) // 이미지 크기 조정하기
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: -5, y: 5)
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
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(height: 25)
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
                .padding(.horizontal)
                .padding(.bottom, -5)
            
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
            .fill(.gray.opacity(0.1))
            .frame(width: 150, height: 200) // 로딩 이미지 크기 조정하기
            .shimmering(active: isLoading)
    }
}

struct ListTypeCellView_Previews: PreviewProvider {
    static var previews: some View {
        ListTypeCellView(bookItem: BookList.Item.preview[0])
    }
}
