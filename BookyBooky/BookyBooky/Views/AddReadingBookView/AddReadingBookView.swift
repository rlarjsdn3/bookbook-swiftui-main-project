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
    
    @State private var selectedDate: Date = Date(timeIntervalSinceNow: 7 * 86_400)
    @State private var isPresentingDateDescSheet = false
    @State private var isPresentingDatePickerSheet = false
    
    // MARK: - PROPERTIES
    
    let searchBookInfo: detailBookInfo.Item
    
    // MARK: - INTIALIZER
    
    init(_ searchBookInfo: detailBookInfo.Item) {
        self.searchBookInfo = searchBookInfo
    }
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            linearGrayGradient
            
            VStack {
                AddReadingBookHeaderView(bookTitle: searchBookInfo.title.refinedTitle)
                
                Spacer(minLength: 0)
                
                LottieBookView()
                    .frame(height: 200)
                
                AddReadingBookTitleView(searchBookInfo, selectedDate: $selectedDate)
            
                Spacer(minLength: 0)
                
                AddReadingBookButtonsView(searchBookInfo, selectedDate: $selectedDate)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
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
        AddReadingBookView(detailBookInfo.Item.preview)
    }
}
