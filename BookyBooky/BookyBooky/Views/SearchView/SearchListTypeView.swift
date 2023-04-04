//
//  BookListCategoryView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchListTypeView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var selectedAnimation = ListType.bestSeller
    
    @Binding var listTypeSelected: ListType
    @Namespace var namespace: Namespace.ID
    
    // MARK: - BODY
    
    var body: some View {
        ScrollViewReader { proxy in
            scrollListTypeButtons(scrollProxy: proxy)
        }
    }
}

// MARK: - EXTENSIONS

extension SearchListTypeView {
    @ViewBuilder
    func scrollListTypeButtons(scrollProxy proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            listTypeButtons(scrollProxy: proxy)
        }
    }
    
    @ViewBuilder
    func listTypeButtons(scrollProxy proxy: ScrollViewProxy) -> some View {
        HStack {
            ForEach(ListType.allCases, id: \.self) { type in
                ListTypeButtonView(
                    listTypeSelected: $listTypeSelected,
                    type: type,
                    scrollProxy: proxy,
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

// MARK: - PREVIEW

struct SearchListTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListTypeView(listTypeSelected: .constant(.itemNewAll))
    }
}
