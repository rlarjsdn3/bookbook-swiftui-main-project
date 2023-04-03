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
    
    var body: some View {
        ZStack {
            if !bookViewModel.bookDetailInfo.isEmpty {
                let bookDetail = bookViewModel.bookDetailInfo[0]
                
                VStack {
                    SearchDetailCoverView(isbn13: $isbn13)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(bookDetail.originalTitle)
                                .font(.title)
                                .fontWeight(.bold)
                                .minimumScaleFactor(0.8)
                                .lineLimit(1)
                            
                            HStack(spacing: 2) {
                                Text(bookDetail.authorInfo)
                                
                                Text("・")
                                
                                Text(bookDetail.publisher)
                            }
                            .font(.headline)
                            .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "heart")
                        }

                    }
                    .frame(height: 60)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    
                    Spacer()
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
