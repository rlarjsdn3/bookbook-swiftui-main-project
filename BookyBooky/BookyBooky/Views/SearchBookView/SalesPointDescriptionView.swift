//
//  SalesPointDescriptionSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SalesPointDescriptionView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - CONSTANT PROPERTIES
    
    let descriptions = [
        "판매 포인트는 판매량과 판매기간에 근거하여 해당 상품의 판매도를 산출한 알라딘만의 판매지수법입니다.",
        "최근 판매분에 가중치를 준 판매점수이며, 팔릴수록 올라가고 덜 팔리면 내려갑니다.",
        "그래서 최근 베스트셀러는 높은 점수이며, 꾸준히 팔리는 스테디셀러들도 어느 정도 포인트를 유지합니다.",
        "'판매 포인트'는 매일매일 업데이트됩니다."
    ]
    
    // MARK: - PROPERTIES

    let theme: Color
    
    // MARK: - INTIALIZER
    
    init(theme: Color) {
        self.theme = theme
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                aboutSalesPointText
                
                salesPointDescLabel
            }
            .padding(.horizontal, 25)
            
            Spacer()
            
            backButton
        }
        // 베젤이 없는 아이폰(iPhone 14 등)은 하단 간격 0으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 하단 간격 18으로 설정
        .padding(.bottom, safeAreaInsets.bottom == 0 ? 20 : 0)
    }
}

// MARK: - EXTENSIONS

extension SalesPointDescriptionView {
    var aboutSalesPointText: some View {
        Text("판매 포인트란?")
            .font(.title2)
            .fontWeight(.bold)
            .padding(.top, 25)
            .padding(.bottom, 15)
    }
    
    var salesPointDescLabel: some View {
        VStack(spacing: 20) {
            ForEach(descriptions, id: \.self) { description in
                HStack(alignment: .firstTextBaseline) {
                    Text("▪︎")
                        .frame(alignment: .top)
                    Text(description)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .foregroundColor(.secondary)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Text("돌아가기")
        }
        .buttonStyle(BottomButtonStyle(backgroundColor: theme))
    }
}

// MARK: - PREVIEW

struct SalesPointDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SalesPointDescriptionView(theme: Color.black)
    }
}
