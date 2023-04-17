//
//  BookAddButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI

struct BookAddButtonsView: View {
    
    let bookInfoItem: BookInfo.Item
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Button {
                
            } label: {
                Text("제목이 마음에 안 드시나요?")
                    .font(.subheadline)
            }
            .padding(.top, 10)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("돌아가기")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(15)
                }
                
                Button {
                    
                } label: {
                    Text("추가하기")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(bookInfoItem.categoryName.refinedCategory.accentColor)
                        .cornerRadius(15)
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct BookAddButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        BookAddButtonsView(bookInfoItem: BookInfo.Item.preview[0])
    }
}
