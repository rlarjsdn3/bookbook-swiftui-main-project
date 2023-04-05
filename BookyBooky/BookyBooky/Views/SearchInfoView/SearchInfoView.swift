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
    
    @EnvironmentObject var bookViewModel: AladinAPIManager
    
    @State private var isLoading = true
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            let item = bookViewModel.BookInfoItem
            
            if !item.isEmpty {
                bookInformation(item: item[0])
            }
        }
        .onAppear {
            hideKeyboard()
            bookViewModel.requestBookDetailAPI(isbn13: isbn13)
        }
        .onDisappear {
            bookViewModel.BookInfoItem.removeAll()
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
                isLoading: $isLoading
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
                isLoading: $isLoading
            )
        }
    }
}

// MARK: - PREVIEW

struct SearchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfoView(isbn13: .constant("9788994492049"))
            .environmentObject(AladinAPIManager())
    }
}
