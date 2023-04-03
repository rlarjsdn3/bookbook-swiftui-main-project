//
//  SearchDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailView: View {
    // MARK: - PROPERTIES
    
    let isbn13: String
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    var body: some View {
        ZStack {
            if !bookViewModel.bookDetailInfo.isEmpty {
                
                
                Text(bookViewModel.bookDetailInfo[0].title)
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
        SearchDetailView(isbn13: "9788994492049")
            .environmentObject(BookViewModel())
    }
}
