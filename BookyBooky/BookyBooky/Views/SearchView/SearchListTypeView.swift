//
//  BookListCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchListTypeView: View {
    @State private var selectedAnimation = ListType.bestSeller
    
    @Binding var listTypeSelected: ListType
    @Namespace var namespace: Namespace.ID
    
    var body: some View {
        scrollListTypeButtons
    }
}

extension SearchListTypeView {
    var scrollListTypeButtons: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                listTypeButtons(scrollProxy: proxy)
            }
        }
    }
}

extension SearchListTypeView {
    @ViewBuilder
    func listTypeButtons(scrollProxy: ScrollViewProxy) -> some View {
        HStack {
            ForEach(ListType.allCases, id: \.self) { type in
                ListTypeButtonView(
                    listTypeSelected: $listTypeSelected,
                    type: type,
                    redearProxy: scrollProxy,
                    selectedAnimation: $selectedAnimation,
                    selectedNamespace: namespace
                )
                .padding(.horizontal, 8)
                .id(type.rawValue)
            }
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }
}

struct SearchListTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListTypeView(listTypeSelected: .constant(.itemNewAll))
    }
}
