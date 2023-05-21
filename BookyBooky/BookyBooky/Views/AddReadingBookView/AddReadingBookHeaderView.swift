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
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Label(bookTitle, systemImage: "chevron.left")
                .frame(width: mainScreen.width * 0.77, alignment: .leading)
                .lineLimit(1)
        }
        .navigationBarItemStyle()
        .padding(4)
    }
}

// MARK: - PREVIEW

struct BookAddHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AddReadingBookHeaderView(bookTitle: "자바의 정석")
    }
}
