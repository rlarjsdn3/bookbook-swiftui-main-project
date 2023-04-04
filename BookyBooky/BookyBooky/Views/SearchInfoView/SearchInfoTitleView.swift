//
//  BookDetailTitleView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchInfoTitleView: View {
    
    // MARK: - PROPERTIES
    
    let bookInfo: BookInfo.Item
    @Binding var isLoading: Bool
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            title
            
            Spacer()
            
            favoriteButton
        }
        .frame(height: 60)
        .padding(.top, 5)
        .padding(.bottom, 0)
        .padding(.horizontal)
    }
}

// MARK: - EXTENSIONS

extension SearchInfoTitleView {
    var title: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(bookInfo.originalTitle)
                .font(.title)
                .fontWeight(.bold)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
            
            HStack(spacing: 2) {
                Text(bookInfo.authorInfo)
                
                Text("・")
                
                Text(bookInfo.publisher)
            }
            .font(.headline)
            .foregroundColor(.secondary)
            .redacted(reason: isLoading ? .placeholder : [])
            .shimmering(active: isLoading)
        }
    }
    
    var favoriteButton: some View {
        // '좋아요' 버튼은 미완성입니다. (디자인, 기능 등)
        Button {
            
        } label: {
            Image(systemName: "heart.fill")
                .foregroundColor(.white)
                .padding()
                .background(bookInfo.category.accentColor) // 카테고리별 강조 색상으로
                .clipShape(Circle())
        }
        .disabled(isLoading)
    }
}

// MARK: - PREVIEW

struct SearchInfoTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfoTitleView(bookInfo: BookInfo.Item.preview[0], isLoading: .constant(false))
    }
}
