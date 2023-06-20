//
//  ListTypeButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchListTabButton: View {
    
    // MARK: - PROPERTIES
    
    let type: BookListTab
    @Binding var selectedListTab: BookListTab
    @Binding var selectedListTabFA: BookListTab
    let scrollProxy: ScrollViewProxy
    let namespace: Namespace.ID
    
    // MARK: - INTIALIZER
    
    init(_ type: BookListTab,
         selectedListTab: Binding<BookListTab>,
         selectedListTabFA: Binding<BookListTab>,
         scrollProxy: ScrollViewProxy,
         namespace: Namespace.ID) {
        self.type = type
        self._selectedListTab = selectedListTab
        self._selectedListTabFA = selectedListTabFA
        self.scrollProxy = scrollProxy
        self.namespace = namespace
    }
    
    // MARK: - BODY
    
    var body: some View {
        searchTabButton
    }
    
    func selectTab() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            selectedListTabFA = type
            scrollProxy.scrollTo(type.rawValue)
            scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
        }
        selectedListTab = type
    }
}

// MARK: - EXTENSIONS

extension SearchListTabButton {
    var searchTabButton: some View {
        Button {
            selectTab()
        } label: {
            tabLabel
        }
        .padding(.vertical, 10)
        .padding([.horizontal, .bottom], 5)
        .overlay(alignment: .bottom) {
            if selectedListTabFA == type {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
            }
        }
    }
    
    var tabLabel: some View {
        Text(type.name)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(selectedListTab == type ? .black : .gray)
    }
}

// MARK: - PREVIEW

struct SearchTabButton_Previews: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { proxy in
            SearchListTabButton(
                .bestSeller,
                selectedListTab: .constant(.bestSeller),
                selectedListTabFA: .constant(.bestSeller),
                scrollProxy: proxy,
                namespace: namespace
            )
        }
    }
}
