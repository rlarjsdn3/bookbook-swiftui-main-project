//
//  SearchSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchSheetView: View {
    @State private var query = ""
    
    var body: some View {
        // 검색 결과가 없으면 '결과 없음' 출력하기
        // 코드 리팩토링 진행하기
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("제목 / 저자 검색", text: $query)
                        .submitLabel(.search)
                        .onSubmit {
                            // '검색' 버튼 클릭 시, 수행할 코드 작성
                        }
                    
                    if !query.isEmpty {
                        Button {
                            query = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 10)
                .background(Color("Background"))
                .cornerRadius(15)
                .padding()
                
                Button {
                    query = ""
                } label: {
                    Text("검색")
                }
                .padding(.trailing)
            }
            
            Spacer()
        }
    }
}

struct SearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetView()
    }
}
