//
//  BookAddView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/12.
//

import SwiftUI
import AlertToast

struct AddCompleteBookView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var addCompleteBookViewData =  AddCompleteBookViewData()
    
    @State private var isPresentingDateDescSheet = false
    @State private var isPresentingDatePickerSheet = false
    
    // MARK: - PROPERTIES
    
    let book: DetailBookInfo.Item
    
    // MARK: - INTIALIZER
    
    init(_ book: DetailBookInfo.Item) {
        self.book = book
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            AddCompleteBookTopBarView(title: book.bookTitle)
            
            Spacer()
            
            AddCompleteBookCenterView(book)
        
            Spacer()
            
            AddCompleteBookButtonGroupView(book)
        }
        .background(linearGrayGradient)
        .navigationBarBackButtonHidden()
        .environmentObject(addCompleteBookViewData)
    }
}

// MARK: - EXTENSIONS

extension AddCompleteBookView {
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

struct AddCompleteBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddCompleteBookView(DetailBookInfo.Item.preview)
    }
}
