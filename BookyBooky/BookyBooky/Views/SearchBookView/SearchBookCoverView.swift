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
    
    // MARK: - PROERTIES
    
    var searchBookInfo: detailBookInfo.Item
    @Binding var isLoadingCoverImage: Bool
    
    // MARK: - INTIALIZER
    
    init(_ searchBookInfo: detailBookInfo.Item, isLoadingCoverImage: Binding<Bool>) {
        self.searchBookInfo = searchBookInfo
        self._isLoadingCoverImage = isLoadingCoverImage
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
            
            asyncCoverImage(searchBookInfo.cover,
                            width: 170, height: mainScreen.height * 0.27
            )
            .onAppear {
                isLoadingCoverImage = false
            }
        }
        .frame(height: mainScreen.height * 0.3)
    }
    
    var coverBackgroundColor: some View {
        Rectangle()
            .fill(searchBookInfo.categoryName.refinedCategory.accentColor.gradient)
            .ignoresSafeArea()
    }
}

// MARK: - PREVIEW

struct SearchInfoCoverView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookCoverView(
            detailBookInfo.Item.preview[0],
            isLoadingCoverImage: .constant(false)
        )
        .environmentObject(AladinAPIManager())
        .previewLayout(.sizeThatFits)
    }
}
