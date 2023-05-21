//
//  BookAddHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI

struct BookAddHeaderView: View {
    
    // MARK: - PROPERTIES
    
    let bookInfoItem: detailBookInfo.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            backButton
            
            Spacer()
        }
        // 베젤이 없는 아이폰(iPhone 14 등)은 수평 간격 0으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 수평 간격 10으로 설정
        .padding(.horizontal, safeAreaInsets.bottom != 0 ? 0 : 10)
    }
}

// MARK: - EXTENSIONS

extension BookAddHeaderView {
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            backLabel
        }
    }
    
    var backLabel: some View {
        Label("\(bookInfoItem.title.refinedTitle)", systemImage: "chevron.left")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(maxWidth: mainScreen.width * 0.66, alignment: .leading)
            .lineLimit(1)
            .padding()
    }
}

// MARK: - PREVIEW

struct BookAddHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        BookAddHeaderView(bookInfoItem: detailBookInfo.Item.preview[0])
    }
}
