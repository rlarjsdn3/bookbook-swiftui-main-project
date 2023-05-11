//
//  BookAddView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/12.
//

import SwiftUI
import AlertToast

struct BookAddView: View {
    
    // MARK: - PROPERTIES
    
    let bookInfoItem: BookInfo.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date.now) ?? Date.now
    @State private var isPresentingDateDescSheet = false
    @State private var isPresentingDatePickerSheet = false
    @State private var isPresentingModifyTitleSheet = false
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.gray.opacity(0.4), .gray.opacity(0.01)],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()
            
            VStack {
                BookAddHeaderView(bookInfoItem: bookInfoItem)
                
                Spacer(minLength: 0)
                
                LottieBookView()
                    .frame(height: 200)
                
                BookAddCenterView(bookInfoItem: bookInfoItem, selectedDate: $selectedDate)
            
                Spacer(minLength: 0)
                
                BookAddButtonsView(bookInfoItem: bookInfoItem, selectedDate: $selectedDate)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - PREVIEW

struct BookAddView_Previews: PreviewProvider {
    static var previews: some View {
        BookAddView(bookInfoItem: BookInfo.Item.preview[0])
    }
}
