//
//  SalesPointDescriptionSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SalesPointDescriptionSheetView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("판매 포인트란?")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 25)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Text("▪︎")
                            .frame(maxHeight: .infinity, alignment: .top)
                        Text("판매 포인트는 판매량과 판매기간에 근거하여 해당 상품의 판매도를 산출한 알라딘만의 판매지수법입니다.")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    
                    HStack {
                        Text("▪︎")
                            .frame(maxHeight: .infinity, alignment: .top)
                        Text("최근 판매분에 가중치를 준 판매점수이며, 팔릴수록 올라가고 덜 팔리면 내려갑니다.")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text("▪︎")
                            .frame(maxHeight: .infinity, alignment: .top)
                        Text("그래서 최근 베스트셀러는 높은 점수이며, 꾸준히 팔리는 스테디셀러들도 어느 정도 포인트를 유지합니다.")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text("▪︎")
                            .frame(maxHeight: .infinity, alignment: .top)
                        Text("'판매 포인트'는 매일매일 업데이트됩니다.")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 25)
    }
}

struct SalesPointDescriptionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SalesPointDescriptionSheetView()
    }
}
