//
//  BookAddView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/12.
//

import SwiftUI

struct BookAddView: View {
    let bookInfoItem: BookInfo.Item
    
    var body: some View {
        VStack {
            Text(bookInfoItem.title.refinedTitle)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct BookAddView_Previews: PreviewProvider {
    static var previews: some View {
        BookAddView(bookInfoItem: BookInfo.Item.preview[0])
    }
}
