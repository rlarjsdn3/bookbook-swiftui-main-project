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
            .frame(width: 150, height: 200) // 로딩 이미지 크기 조정하기
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
            .frame(width: 150, height: 200)
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
