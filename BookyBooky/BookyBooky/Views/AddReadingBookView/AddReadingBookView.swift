//
//  BookAddView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/12.
//

import SwiftUI
import AlertToast

struct AddReadingBookView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDate = Date(timeIntervalSinceNow: 7 * 86_400)
    @State private var isPresentingDateDescSheet = false
    @State private var isPresentingDatePickerSheet = false
    
    // MARK: - PROPERTIES
    
    let bookItem: detailBookItem.Item
    
    // MARK: - INTIALIZER
    
    init(_ bookItem: detailBookItem.Item) {
        self.bookItem = bookItem
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            AddReadingBookTopBarView(title: bookItem.bookTitle)
            
            Spacer()
            
            AddReadingBookCenterView(
                bookItem,
                selectedDate: $selectedDate
            )
        
            Spacer()
            
            AddReadingBookButtonGroupView(
                bookItem,
                selectedDate: $selectedDate
            )
        }
        .background(linearGrayGradient)
        .navigationBarBackButtonHidden()
    }
}

// MARK: - EXTENSIONS

extension AddReadingBookView {
    var linearGrayGradient: some View {
        LinearGradient(
            colors: [.gray.opacity(0.4), .gray.opacity(0.01)],
            startPoint: .bottom,
            endPoint: .top
        )
        .ignoresSafeArea()
    }
}

// MARK: - PREVIEW

struct BookAddView_Previews: PreviewProvider {
    static var previews: some View {
        AddReadingBookView(detailBookItem.Item.preview)
    }
}
