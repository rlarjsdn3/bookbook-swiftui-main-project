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
    @Binding var isbn13: String
    @Binding var isLoading: Bool
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            backgroundRectangle
            
            backButton
            
            asyncImage
        }
        .frame(height: mainScreen.height * BACKGROUND_HEIGHT_RATIO)
    }
}

// MARK: - EXTENSIONS

extension SearchInfoCoverView {
    var backgroundRectangle: some View {
        Rectangle()
            .fill(bookInfo.category.accentColor.gradient)
            .ignoresSafeArea()
    }
    
    var backButton: some View {
        VStack {
            HStack {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        isbn13 = ""
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(bookInfo.category.foregroundColor)
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .padding()
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
                isbn13: .constant("9788994492049"),
                isLoading: .constant(false)
            )
            .environmentObject(BookViewModel())
        }
    }
}
