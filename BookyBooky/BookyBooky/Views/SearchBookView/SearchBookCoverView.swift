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
    
    var bookItem: detailBookItem.Item
    @Binding var isLoadingCoverImage: Bool
    
    // MARK: - INTIALIZER
    
    init(_ bookItem: detailBookItem.Item, isLoadingCoverImage: Binding<Bool>) {
        self.bookItem = bookItem
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
            
            asyncCoverImage(bookItem.cover,
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
            .fill(bookItem.categoryName.refinedCategory.themeColor.gradient)
            .ignoresSafeArea()
    }
}

// MARK: - PREVIEW

struct SearchInfoCoverView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookCoverView(
            detailBookItem.Item.preview,
            isLoadingCoverImage: .constant(false)
        )
        .environmentObject(AladinAPIManager())
        .previewLayout(.sizeThatFits)
    }
}
