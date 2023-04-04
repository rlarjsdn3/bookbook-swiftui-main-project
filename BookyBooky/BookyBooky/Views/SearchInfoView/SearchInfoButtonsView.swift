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
            provideBookDB
            
            HStack {
                backButton
                
                addButton
            }
            .padding([.horizontal, .bottom])
        }
    }
}

// MARK: - EXTENSIONS

extension SearchInfoButtonsView {
    var provideBookDB: some View {
        HStack(spacing: 0) {
            Text("도서 DB 제공 : ")
            
            Link("알라딘 인터넷 서점", destination: URL(string: "https://www.aladin.co.kr")!)
                .disabled(isLoading)
        }
        .font(.caption)
        .redacted(reason: isLoading ? .placeholder : [])
        .shimmering(active: isLoading)
    }
    
    var backButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                isbn13 = ""
            }
        } label: {
            backLabel
        }
    }
    
    var backLabel: some View {
        Text("돌아가기")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.2))
            .cornerRadius(15)
    }
    
    var addButton: some View {
        Button {
            
        } label: {
            addLabel
        }
        .disabled(isLoading)
    }
    
    var addLabel: some View {
        Text("추가하기")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(bookInfo.category.accentColor)
            .cornerRadius(15)
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
