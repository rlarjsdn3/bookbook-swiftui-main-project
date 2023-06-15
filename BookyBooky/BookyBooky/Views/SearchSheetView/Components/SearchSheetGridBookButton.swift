//
//  SearchSheetBookGridButton.swift
//  BookyBooky
//
//  Created by 김건우 on 6/12/23.
//

import SwiftUI

struct SearchSheetGridBookButton: View {
    
    let bookItem: briefBookInfo.Item
    
    @State private var isPresentingSearchBookView = false
    
    var body: some View {
        VStack {
            asyncCoverImage(
                bookItem.cover,
                width: 150, height: 200,
                coverShape: RoundedRect()
            )
            
            bookTitleText
            
            bookAuthorText
        }
        .onTapGesture {
            hideKeyboard()
            isPresentingSearchBookView = true
        }
        .navigationDestination(isPresented: $isPresentingSearchBookView) {
            SearchBookView(bookItem.isbn13, viewType: .navigationStack)
            
        }
    }
    
    var bookTitleText: some View {
        Text(bookItem.bookTitle)
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(height: 25)
            .padding(.horizontal)
            .padding(.bottom, -5)
    }
    
    var bookAuthorText: some View {
        Text(bookItem.bookAuthor)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: 100)
    }
}

#Preview {
    SearchSheetGridBookButton(bookItem: .preview)
}
