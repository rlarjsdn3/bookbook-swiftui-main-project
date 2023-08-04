//
//  SearchDetailCoverView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import Shimmer

struct SearchBookCoverView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    @EnvironmentObject var searchBookViewData: SearchBookViewData
    
    // MARK: - PROERTIES
    
    let book: DetailBookInfo.Item

    // MARK: - INTIALIZER
    
    init(_ book: DetailBookInfo.Item) {
        self.book = book
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookCoverArea
    }
}

// MARK: - EXTENSIONS

extension SearchBookCoverView {
    var bookCoverArea: some View {
        ZStack {
            backgroundColor
            
            asyncCoverImage(
                book.cover,
                width: safeAreaInsets.bottom == 0 ? 140 : 170,
                height: mainScreen.height * 0.27
            )
            .onAppear {
                // NOTE: - DispatchQueue를 사용해 일정 텀을 주지 않는다면
                //       - 화면이 제대로 리-렌더링되지 않습니다. (2023. 7. 6)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    searchBookViewData.isLoadingCoverImage = false
                }
                print(mainScreen.width * 0.45)
            }
        }
        .frame(height: mainScreen.height * 0.3)
    }
    
    var backgroundColor: some View {
        Rectangle()
            .fill(book.categoryName.refinedCategory.themeColor.gradient)
            .ignoresSafeArea()
    }
}

// MARK: - PREVIEW

#Preview {
    SearchBookCoverView(DetailBookInfo.Item.preview)
        .environmentObject(AladinAPIManager())
        .environmentObject(SearchBookViewData())
}
