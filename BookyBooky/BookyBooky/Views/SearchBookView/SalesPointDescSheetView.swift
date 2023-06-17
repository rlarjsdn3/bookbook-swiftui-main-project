//
//  SalesPointDescriptionSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SalesPointDescSheetView: View {
    
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
            // 베젤이 없는 아이폰(iPhone 14 등)은 수평 간격 25으로 설정
            // 베젤이 있는 아이폰(iPhone SE 등)은 수평 간격 15으로 설정
            .padding(.horizontal, safeAreaInsets.bottom == 0 ? 15 : 25)
            
            Spacer()
            
            backButton
        }
        // 베젤이 없는 아이폰(iPhone 14 등)은 하단 간격 0으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 하단 간격 18으로 설정
        .padding(safeAreaInsets.bottom == 0 ? 18 : 0)
        // 베젤이 없는 아이폰(iPhone 14 등)은 시트 높이를 380으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 시트 높이를 420으로 설정
        .presentationDetents([.height(safeAreaInsets.bottom == 0 ? 450 : 410)])
        // 시트(Sheet)의 굴곡 정도를 30으로 설정
        .presentationCornerRadius(30)
    }
}

// MARK: - EXTENSIONS

extension SalesPointDescSheetView {
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

struct SalesPointDescriptionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SalesPointDescSheetView(theme: Color.black)
    }
}
