//
//  BookListCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct ListCategoryView: View {
    @Binding var selected: BookListType
    @Namespace var underlineAnimation: Namespace.ID
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(BookListType.allCases, id: \.self) { type in
                        ListTypeButtonView(
                            selected: $selected,
                            type: type,
                            proxy: proxy,
                            namespace: underlineAnimation
                        )
                        .padding(.horizontal, 8)
                    }
                }
                .padding(.leading, 8)
                .padding(.trailing, 8)
            }
        }
    }
}

struct BookListCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ListCategoryView(selected: .constant(.itemNewAll))
    }
}
