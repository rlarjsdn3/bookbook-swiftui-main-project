//
//  SearchDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var isbn13: String
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var isLoading = true
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            if !bookViewModel.bookDetailInfo.isEmpty {
                let bookInfo = bookViewModel.bookDetailInfo[0]
                
                VStack {
                    SearchDetailCoverView(
                        bookInfo: bookInfo,
                        isbn13: $isbn13,
                        isLoading: $isLoading
                    )
                    
                    SearchDetailTitleView(bookInfo: bookInfo, isLoading: $isLoading)
                    
                    SearchDetailSubInfoView(bookInfo: bookInfo, isLoading: $isLoading)
                    
                    Divider()
                    
                    SearchDetailDescriptionView(bookInfo: bookInfo, isLoading: $isLoading)
                    
                    Spacer()
                    
                    SearchDetailButtonsView(bookInfo: bookInfo, isbn13: $isbn13, isLoading: $isLoading)
                }
            }
        }
        .onAppear {
            bookViewModel.requestBookDetailAPI(isbn13: isbn13)
        }
        .onDisappear {
            bookViewModel.bookDetailInfo.removeAll()
        }
    }
}

struct SearchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDetailView(isbn13: .constant("9788994492049"))
            .environmentObject(BookViewModel())
    }
}
