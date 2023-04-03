//
//  SearchDetailSubInfoView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailSubInfoView: View {
    var bookInfo: BookDetail.Item
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 8) {
                Text("판매 포인트")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("\(bookInfo.salesPoint)")
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("페이지")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("\(bookInfo.subInfo.itemPage)")
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("카테고리")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(bookInfo.category.rawValue)
            }
            
            Spacer()
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(15)
        .padding(.horizontal)
        .frame(height: 100)
    }
}

struct SearchDetailSubInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDetailSubInfoView(bookInfo: BookDetail.Item.preview[0])
    }
}
