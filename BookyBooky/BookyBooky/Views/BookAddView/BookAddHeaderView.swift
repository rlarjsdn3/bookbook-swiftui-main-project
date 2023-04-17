//
//  BookAddHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI

struct BookAddHeaderView: View {
    
    // MARK: - PROPERTIES
    
    let bookInfoItem: BookInfo.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Label("\(bookInfoItem.title.refinedTitle)", systemImage: "chevron.left")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: mainScreen.width * 0.66, alignment: .leading)
                    .lineLimit(1)
                    .padding()
            }
            
            Spacer()
        }
    }
}

struct BookAddHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        BookAddHeaderView(bookInfoItem: BookInfo.Item.preview[0])
    }
}
