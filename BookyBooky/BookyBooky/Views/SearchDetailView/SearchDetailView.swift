//
//  SearchDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailView: View {
    // MARK: - PROPERTIES
    
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var isbn13: String
    
    var body: some View {
        ZStack {
            if !bookViewModel.bookDetailInfo.isEmpty {
                VStack {
                    ZStack {
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
                        
                        AsyncImage(url: URL(string: bookViewModel.bookDetailInfo[0].cover)) { image in
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
                    
                    Spacer()
                    
                    Text(bookViewModel.bookDetailInfo[0].title)
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
