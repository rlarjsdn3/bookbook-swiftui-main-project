//
//  SearchDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailView: View {
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var isbn13: String
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            if !bookViewModel.bookDetailInfo.isEmpty {
                let bookInfo = bookViewModel.bookDetailInfo[0]
                
                VStack {
                    SearchDetailCoverView(
                        bookInfo: bookInfo,
                        isbn13: $isbn13
                    )
                    
                    SearchDetailTitleView(bookInfo: bookInfo)
                    
                    SearchDetailSubInfoView(bookInfo: bookInfo)
                    
                    Divider()
                    
                    SearchDetailDescriptionView(bookInfo: bookInfo)
                    
                    Spacer()
                    
                    VStack {
                        Text("도서 DB 제공 : 알라딘 인터넷서점(www.aladin.co.kr)")
                            .font(.caption)
                        
                        HStack {
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                    isbn13 = ""
                                }
                            } label: {
                                Text("돌아가기")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .background(.gray.opacity(0.2))
                                    .cornerRadius(15)
                            }
                            
                            Button {
                                
                            } label: {
                                Text("추가하기")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .background(bookInfo.category.accentColor) // 카테고리 별 강조 색상으로
                                    .cornerRadius(15)
                            }
                        }
                        .padding([.horizontal, .bottom])
                    }
                }
            } else {
                // 로딩 뷰 따로 출력하기
            }
        }
        .onAppear {
            bookViewModel.requestBookDetailAPI(isbn13: isbn13)
        }
    }
}

struct SearchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDetailView(isbn13: .constant("9788994492049"))
            .environmentObject(BookViewModel())
    }
}
