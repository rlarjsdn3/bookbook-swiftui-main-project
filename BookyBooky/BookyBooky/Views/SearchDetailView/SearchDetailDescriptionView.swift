//
//  SearchDetailDescriptionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailDescriptionView: View {
    let bookInfo: BookDetail.Item
    
    var body: some View {
        VStack {
            HStack {
                Text("이 책에 관하여")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Link(destination: URL(string: bookInfo.link)!) {
                    Text("자세히 보기")
                }
            }
            .padding(.top, 5)
            .padding(.horizontal)
            
            ScrollView(showsIndicators: false) {
                Text(bookInfo.description)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)
        }
    }
}

struct SearchDetailDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDetailDescriptionView(bookInfo: BookDetail.Item.preview[0])
    }
}
