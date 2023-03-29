//
//  BookListCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct BookListCategoryView: View {
    @Binding var selected: ListType
    @Namespace var namespace: Namespace.ID
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(ListType.allCases, id: \.self) { type in
                    ListTypeButtonView(
                        selected: $selected,
                        type: type,
                        namespace: namespace
                    )
                    .padding(.horizontal, 5)
                }
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
        }
    }
}

struct BookListCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        BookListCategoryView(selected: .constant(.itemNewAll))
    }
}
