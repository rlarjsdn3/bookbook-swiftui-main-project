//
//  SearchDetailCoverView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailCoverView: View {
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var isbn13: String
    
    // MARK: - BODY
    
    var body: some View {
            ZStack {
                let bookDetail = bookViewModel.bookDetailInfo[0]
                
                Rectangle()
                    .fill(.gray.gradient)
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
                
                AsyncImage(url: URL(string: bookDetail.cover)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                } placeholder: {
                    // 로딩 이미지 추가
                }
                
            }
            .frame(height: 230)
    }
}

// 참고: 해당 뷰가 API로부터 직접 상세 정보(DetailInfo)를 불러오지 않으므로 프리뷰에 에러가 발생합니다.
struct SearchDetailCoverView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDetailCoverView(isbn13: .constant("9788994492049"))
            .environmentObject(BookViewModel())
    }
}
