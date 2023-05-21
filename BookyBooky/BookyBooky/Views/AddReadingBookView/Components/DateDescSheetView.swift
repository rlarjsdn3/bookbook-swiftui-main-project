//
//  DateDescSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/18.
//

import SwiftUI

struct DateDescSheetView: View {
    
    // MARK: - CONSTANT PROPERTIES
    
    let descriptions = [
        "(설명)",
        "(설명)",
        "(설명)",
        "(설명)"
    ]
    
    // MARK: - PROPERTIES

    let bookInfo: detailBookInfo.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            aboutSalesPointLabel
            
            scrollDescriptions
            
            backButton
        }
        // 베젤이 없는 아이폰(iPhone 14 등)은 수평 간격 25으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 수평 간격 15으로 설정
        .padding(.horizontal, safeAreaInsets.bottom == 0 ? 15 : 25)
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

extension DateDescSheetView {
    var aboutSalesPointLabel: some View {
        Text("날짜를 계산하는 방법")
            .font(.title2)
            .fontWeight(.bold)
            .padding(.top, 25)
    }
    
    var scrollDescriptions: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(descriptions, id: \.self) { description in
                    HStack {
                        Text("▪︎")
                            .frame(maxHeight: .infinity, alignment: .top)
                        Text(description)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .foregroundColor(.secondary)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            backLabel
        }
        .padding(.bottom)
    }
    
    var backLabel: some View {
        Text("나가기")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(bookInfo.categoryName.refinedCategory.accentColor)
            .cornerRadius(15)
    }
}


struct DateDescSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DateDescSheetView(bookInfo: detailBookInfo.Item.preview[0])
    }
}
