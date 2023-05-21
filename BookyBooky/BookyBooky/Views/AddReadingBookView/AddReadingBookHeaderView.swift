//
//  BookAddHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI

struct AddReadingBookHeaderView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - PROPERTIES
    
    let bookTitle: String
    
    // MARK: - INTIALIZER
    
    init(bookTitle: String) {
        self.bookTitle = bookTitle
    }
    
    // MARK: - BODY
    
    var body: some View {
        navigationBar
    }
}

// MARK: - EXTENSIONS

extension AddReadingBookHeaderView {
    var navigationBar: some View {
        HStack {
            backButton
            
            Spacer()
        }
        // 베젤이 없는 아이폰(iPhone 14 등)은 수평 간격 0으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 수평 간격 10으로 설정
        .padding(.horizontal, safeAreaInsets.bottom != 0 ? 0 : 10)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Label(bookTitle, systemImage: "chevron.left")
        }
        .navigationBarItemStyle()
    }
}

// MARK: - PREVIEW

struct BookAddHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AddReadingBookHeaderView(bookTitle: "자바의 정석")
    }
}
