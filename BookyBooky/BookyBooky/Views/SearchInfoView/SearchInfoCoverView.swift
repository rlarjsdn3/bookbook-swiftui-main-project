//
//  SearchDetailCoverView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import Shimmer

struct SearchInfoCoverView: View {
    // MARK: - CONSTANT PROPERTIES
    
    let COVER_HEGHT_RATIO = 0.27        // 화면 사이즈 대비 표지(커버) 이미지 높이 비율
    let BACKGROUND_HEIGHT_RATIO = 0.3   // 화면 사이즈 대비 바탕 색상 높이 비율
    
    
    // MARK: - PROERTIES
    
    var bookInfo: BookInfo.Item
    @Binding var isLoading: Bool
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            backgroundRectangle
            
            asyncImage
        }
        .frame(height: mainScreen.height * BACKGROUND_HEIGHT_RATIO)
    }
}

// MARK: - EXTENSIONS

extension SearchInfoCoverView {
    var backgroundRectangle: some View {
        Rectangle()
            .fill(bookInfo.categoryName.refinedCategory.accentColor.gradient)
            .ignoresSafeArea()
    }
    
    var asyncImage: some View {
        AsyncImage(url: URL(string: bookInfo.cover),
                   transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: mainScreen.height * COVER_HEGHT_RATIO)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        )
                    )
                    .onAppear {
                        isLoading = false
                    }
            case .empty:
                loadingCover
            case .failure(_):
                loadingCover
            @unknown default:
                loadingCover
                
            }
        }
    }
    
    var loadingCover: some View {
        Rectangle()
            .fill(.gray.opacity(0.2))
            .shimmering()
    }
}

// MARK: - PREVIEW

struct SearchInfoCoverView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            SearchInfoCoverView(
                bookInfo: BookInfo.Item.preview[0],
                isLoading: .constant(false)
            )
            .environmentObject(AladinAPIManager())
        }
    }
}
