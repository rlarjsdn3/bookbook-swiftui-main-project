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
    let viewType: SearchSheetViewType
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @State private var isLoading = true
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            // 도서 상세 데이터가 정상적으로 로드된 경우
            if !aladinAPIManager.BookInfoItem.isEmpty {
                bookInformation(item: aladinAPIManager.BookInfoItem[0]) // 상세 뷰 출력하기
            }
        }
        .onAppear {
            aladinAPIManager.requestBookDetailAPI(isbn13: isbn13)
            hideKeyboard()
        }
        .onDisappear {
            aladinAPIManager.BookInfoItem.removeAll()
        }
    }
}

// MARK: - EXTENSIONS

extension SearchInfoView {
    func bookInformation(item: BookInfo.Item) -> some View {
        VStack {
            SearchInfoCoverView(
                bookInfo: item,
                isbn13: $isbn13,
                isLoading: $isLoading,
                viewType: viewType
            )
            
            SearchInfoTitleView(
                bookInfo: item,
                isLoading: $isLoading
            )
            
            SearchInfoBoxView(
                bookInfo: item,
                isLoading: $isLoading
            )
            
            Divider()
            
            SearchInfoDescView(
                bookInfo: item,
                isLoading: $isLoading
            )
            
            Spacer()
            
            SearchInfoButtonsView(
                bookInfo: item,
                isbn13: $isbn13,
                isLoading: $isLoading,
                viewType: viewType
            )
        }
    }
}

// MARK: - PREVIEW

struct SearchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfoView(isbn13: .constant("9788994492049"), viewType: .search(isbn13: "9788994492049"))
            .environmentObject(AladinAPIManager())
    }
}
