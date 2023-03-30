//
//  BookListCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct ListTypeView: View {
    @State private var selectedAnimation = ListType.bestSeller
    
    @Binding var listTypeSelected: ListType
    @Namespace var namespace: Namespace.ID
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(ListType.allCases, id: \.self) { type in
                        ListTypeButtonView(
                            listTypeSelected: $listTypeSelected,
                            type: type,
                            redearProxy: proxy,
                            selectedAnimation: $selectedAnimation,
                            selectedNamespace: namespace
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

struct ListTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ListTypeView(listTypeSelected: .constant(.itemNewAll))
    }
}
