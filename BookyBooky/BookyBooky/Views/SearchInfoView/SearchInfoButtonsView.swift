//
//  SearchDetailButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchInfoButtonsView: View {
    
    // MARK: - PROPERTIES
    
    let bookInfo: BookInfo.Item
    @Binding var isbn13: String
    @Binding var isLoading: Bool
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("도서 DB 제공 : ")
                
                Link("알라딘 인터넷 서점", destination: URL(string: "https://www.aladin.co.kr")!)
                    .disabled(isLoading)
            }
            .font(.caption)
            .redacted(reason: isLoading ? .placeholder : [])
            .shimmering(active: isLoading)
            
            HStack {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        isbn13 = ""
                    }
                } label: {
                    Text("돌아가기")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(15)
                }
                
                Button {
                    
                } label: {
                    Text("추가하기")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(bookInfo.category.accentColor) // 카테고리 별 강조 색상으로
                        .cornerRadius(15)
                }
                .disabled(isLoading)
            }
            .padding([.horizontal, .bottom])
        }
    }
}

// MARK: - PREVIEW

struct SearchInfoButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfoButtonsView(
            bookInfo: BookInfo.Item.preview[0],
            isbn13: .constant("9788994492049"),
            isLoading: .constant(false)
        )
    }
}
