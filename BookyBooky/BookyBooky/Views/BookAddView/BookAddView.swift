//
//  BookAddView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/12.
//

import SwiftUI

struct BookAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let bookInfoItem: BookInfo.Item
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
    //                    .foregroundColor(bookInfoItem.categoryName.refinedCategory.foregroundColor)
                        .padding()
                }
                
                Spacer()
            }
            .background(Color("Background"))
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topLeading) {
            
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct BookAddView_Previews: PreviewProvider {
    static var previews: some View {
        BookAddView(bookInfoItem: BookInfo.Item.preview[0])
    }
}
