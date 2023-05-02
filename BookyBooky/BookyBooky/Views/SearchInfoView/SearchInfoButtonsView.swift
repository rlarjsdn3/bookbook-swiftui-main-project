//
//  SearchDetailButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import RealmSwift

struct SearchInfoButtonsView: View {
    
    // MARK: - PROPERTIES
    
    let bookInfo: BookInfo.Item
    @Binding var isLoading: Bool
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(ReadingBook.self) var completeTargetBooks
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            provideBookDB
            
            HStack {
                backButton
                
                addButton
            }
            .padding(.horizontal)
            // 베젤이 없는 아이폰(iPhone 14 등)은 하단 간격 0으로 설정
            // 베젤이 있는 아이폰(iPhone SE 등)은 하단 간격 20으로 설정
            .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
        }
    }
    
    func isExist() -> Bool {
        for book in completeTargetBooks where book.isbn13 == bookInfo.isbn13 {
            return false
        }
        return true
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
            dismiss()
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
        // 이미 목표 도서에 추가되어 있는 경우, 버튼 잠그기 (안 보이게 하기)
        Group {
            if isExist() {
                NavigationLink {
                    BookAddView(bookInfoItem: bookInfo)
                } label: {
                    addLabel
                }
                .disabled(isLoading)
            }
        }
    }
    
    var addLabel: some View {
        Text("추가하기")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(bookInfo.categoryName.refinedCategory.accentColor)
            .cornerRadius(15)
    }
}

// MARK: - PREVIEW

struct SearchInfoButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfoButtonsView(
            bookInfo: BookInfo.Item.preview[0],
            isLoading: .constant(false)
        )
    }
}
