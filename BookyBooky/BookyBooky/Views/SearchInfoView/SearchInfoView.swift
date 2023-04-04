//
//  SearchDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchInfoView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var isbn13: String
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var isLoading = true
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            if !bookViewModel.BookInfoItem.isEmpty {
                let bookInfo = bookViewModel.BookInfoItem[0]
                
                VStack {
                    SearchInfoCoverView(
                        bookInfo: bookInfo,
                        isbn13: $isbn13,
                        isLoading: $isLoading
                    )
                    
                    SearchInfoTitleView(
                        bookInfo: bookInfo,
                        isLoading: $isLoading
                    )
                    
                    SearchInfoBoxView(
                        bookInfo: bookInfo,
                        isLoading: $isLoading
                    )
                    
                    Divider()
                    
                    SearchInfoDescView(
                        bookInfo: bookInfo,
                        isLoading: $isLoading
                    )
                    
                    Spacer()
                    
                    SearchInfoButtonsView(
                        bookInfo: bookInfo,
                        isbn13: $isbn13,
                        isLoading: $isLoading
                    )
                }
            }
        }
        .onAppear {
            bookViewModel.requestBookDetailAPI(isbn13: isbn13)
        }
        .onDisappear {
            bookViewModel.BookInfoItem.removeAll()
        }
    }
}

// MARK: - PREVIEW

struct SearchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfoView(isbn13: .constant("9788994492049"))
            .environmentObject(BookViewModel())
    }
}
