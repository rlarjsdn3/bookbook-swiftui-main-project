//
//  BookDetailTitleView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailTitleView: View {
    let bookInfo: BookDetail.Item
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(bookInfo.originalTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    Text(bookInfo.authorInfo)
                    
                    Text("・")
                    
                    Text(bookInfo.publisher)
                }
                .font(.headline)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // '좋아요' 버튼은 미완성입니다. (디자인, 기능 등)
            Button {
                
            } label: {
                Image(systemName: "heart.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(.pink)
                    .clipShape(Circle())
            }

        }
        .frame(height: 60)
        .padding([.top, .horizontal])
        .padding(.bottom, 8)
    }
}

struct BookDetailTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDetailTitleView(bookInfo: BookDetail.Item.preview[0])
    }
}
