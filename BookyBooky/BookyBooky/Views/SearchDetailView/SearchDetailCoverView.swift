//
//  SearchDetailCoverView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailCoverView: View {
    // MARK: - CONSTANT PROPERTIES
    
    let COVER_HEGHT_RATIO = 0.27        // 화면 사이즈 대비 표지(커버) 이미지 높이 비율
    let BACKGROUND_HEIGHT_RATIO = 0.3   // 화면 사이즈 대비 바탕 색상 높이 비율
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    // MARK: - PROERTIES
    
    var bookInfo: BookDetail.Item
    @Binding var isbn13: String
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray.gradient) // 카테고리 별 강조색상으로
                .ignoresSafeArea()
            
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
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding()
            
            AsyncImage(url: URL(string: bookInfo.cover)) { image in
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
            } placeholder: {
                // 로딩 이미지 추가
            }
        }
        .frame(height: mainScreen.height * BACKGROUND_HEIGHT_RATIO)
    }
}

struct SearchDetailCoverView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            SearchDetailCoverView(
                bookInfo: BookDetail.Item.preview[0],
                isbn13: .constant("9788994492049")
            )
            .environmentObject(BookViewModel())
        }
    }
}
