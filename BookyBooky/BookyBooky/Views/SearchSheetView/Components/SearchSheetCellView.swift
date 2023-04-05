//
//  SearchSheetCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/01.
//

import SwiftUI

struct SearchSheetCellView: View {
    
    // MARK: - CONSTANT PROPERTIES
    
    let COVER_HEIGHT: CGFloat = 200 // 표지(커버) 이미지 높이
    let COVER_WIDTH_RATIO = 0.32 // 화면 사이즈 대비 표지(커버) 너비 비율
    let TEXT_HEIGHT: CGFloat = 130 // 책 정보 도형 높이
    let TEXT_WIDTH_RATIO = 0.71 // 화면 사이즈 대미 책 정보 도형 너비 비율
    
    // MARK: - PROPERTIES
    
    let bookItem: BookList.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isLoading = true
    
    // MARK: - BODY
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                leftBookSearchShape(geometryProxy: proxy)

                rightBookSearchShape(geometryProxy: proxy)
            }
        }
        .frame(height: COVER_HEIGHT)
        .padding(.top, 18)
    }
}

// MARK: - EXTENSIONS

extension SearchSheetCellView {
    var title: some View {
        Text(bookItem.title.refinedTitle)
            .font(.title3)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .padding(.bottom, 2)
    }
    
    var subInfo: some View {
        VStack (alignment: .leading) {
            author
            
            publisher
            
            Spacer()
            
            pubDate
        }
        .foregroundColor(.secondary)
    }
    
    var author: some View {
        Text(bookItem.author.refinedAuthor)
            .foregroundColor(.primary)
            .fontWeight(.bold)
    }
    
    var publisher: some View {
        HStack(spacing: 2) {
            Text(bookItem.publisher)
            
            Text("・")
            
            Text(bookItem.categoryName.refinedCategory.rawValue)
        }
        .fontWeight(.semibold)
    }
    
    var pubDate: some View {
        Text(bookItem.pubDate.refinedPublishDate, style: .date)
    }
}

extension SearchSheetCellView {
    @ViewBuilder
    func leftBookSearchShape(geometryProxy proxy: GeometryProxy) -> some View {
        HStack {
            asyncImage(geometryProxy: proxy)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func rightBookSearchShape(geometryProxy proxy: GeometryProxy) -> some View {
        HStack {
            Spacer()
            
            ZStack {
                TextShape()
                    .fill(bookItem.categoryName.refinedCategory.accentColor)
                    .offset(y: 4)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: -5, y: 5)
                
                TextShape()
                    .fill(.white)
                    .offset(y: -4)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 5, y: 5)
                
                
                VStack( alignment: .leading, spacing: 2) {
                    title
                    
                    subInfo
                }
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
                .padding()
            }
            .frame(
                width: proxy.size.width * TEXT_WIDTH_RATIO,
                height: TEXT_HEIGHT
            )
        }
    }
    
    @ViewBuilder
    func asyncImage(geometryProxy proxy: GeometryProxy) -> some View {
        AsyncImage(
            url: URL(string: bookItem.cover),
            transaction: Transaction(animation: .default)) { phase in
                switch phase {
                case .success(let image):
                    cover(image, geometryProxy: proxy)
                case .failure(_):
                    loadingCover(geometryProxy: proxy)
                case.empty:
                    loadingCover(geometryProxy: proxy)
                @unknown default:
                    loadingCover(geometryProxy: proxy)
                }
            }
            .shadow(color: .black.opacity(0.1), radius: 8, x: -5, y: 5)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 5, y: -5)
    }
    
    @ViewBuilder
    func cover(_ image: Image, geometryProxy proxy: GeometryProxy) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(
                width: proxy.size.width * COVER_WIDTH_RATIO,
                height: COVER_HEIGHT
            )
            .clipShape(CoverShape())
            .onAppear {
                isLoading = false
            }
    }
    
    @ViewBuilder
    func loadingCover(geometryProxy proxy: GeometryProxy) -> some View {
        CoverShape()
            .fill(.gray.opacity(0.25))
            .frame(
                width: proxy.size.width * COVER_WIDTH_RATIO,
                height: COVER_HEIGHT
            )
            .shimmering(active: isLoading)
    }
}

// MARK: - PREVIEW

struct SearchSheetCellView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetCellView(bookItem: BookList.Item.preview[0])
    }
}
