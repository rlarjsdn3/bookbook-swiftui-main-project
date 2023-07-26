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
    
    let bookItem: detailBookItem.Item

    // MARK: - INTIALIZER
    
    init(_ bookItem: detailBookItem.Item) {
        self.bookItem = bookItem
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookCover
    }
}

// MARK: - EXTENSIONS

extension SearchBookCoverView {
    var bookCover: some View {
        ZStack {
            coverBackgroundColor
            
            asyncCoverImage(
                bookItem.cover,
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
    
    var coverBackgroundColor: some View {
        Rectangle()
            .fill(bookItem.categoryName.refinedCategory.themeColor.gradient)
            .ignoresSafeArea()
    }
}

// MARK: - PREVIEW

struct SearchInfoCoverView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookCoverView(detailBookItem.Item.preview)
            .environmentObject(AladinAPIManager())
            .environmentObject(SearchBookViewData())
    }
}
