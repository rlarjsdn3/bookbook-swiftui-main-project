//
//  SearchDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailView: View {
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var isbn13: String
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            if !bookViewModel.bookDetailInfo.isEmpty {
                let bookInfo = bookViewModel.bookDetailInfo[0]
                
                VStack {
                    SearchDetailCoverView(
                        bookInfo: bookInfo,
                        isbn13: $isbn13
                    )
                    
                    SearchDetailTitleView(bookInfo: bookInfo)
                    
                    SearchDetailSubInfoView(bookInfo: bookInfo)
                    
                    Divider()
                    
                    SearchDetailDescriptionView(bookInfo: bookInfo)
                    
                    Spacer()
                }
            } else {
                // 로딩 뷰 따로 출력하기
            }
        }
        .onAppear {
            bookViewModel.requestBookDetailAPI(isbn13: isbn13)
        }
    }
}

struct SearchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDetailView(isbn13: .constant("9788994492049"))
            .environmentObject(BookViewModel())
    }
}
