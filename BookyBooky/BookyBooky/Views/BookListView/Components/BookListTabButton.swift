//
//  ListTypeButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct BookListTabButton: View {
    
    // MARKL - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookListViewData: BookListViewData
    
    // MARK: - PROPERTIES
    
    let type: BookListType
    let scrollProxy: ScrollViewProxy
    let namespace: Namespace.ID
    
    // MARK: - INTIALIZER
    
    init(_ type: BookListType,
         scrollProxy: ScrollViewProxy,
         namespace: Namespace.ID) {
        self.type = type
        self.scrollProxy = scrollProxy
        self.namespace = namespace
    }
    
    // MARK: - BODY
    
    var body: some View {
        searchTabButton
    }
    
    func selectTab() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            bookListViewData.selectedListTabFA = type
            scrollProxy.scrollTo(type.rawValue)
            scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
        }
        bookListViewData.selectedListTab = type
        print(bookListViewData.selectedListTab)
    }
}

// MARK: - EXTENSIONS

extension BookListTabButton {
    var searchTabButton: some View {
        Button {
            selectTab()
        } label: {
            tabLabel
        }
        .padding(.vertical, 10)
        .padding([.horizontal, .bottom], 5)
        .overlay(alignment: .bottom) {
            if bookListViewData.selectedListTabFA == type {
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
            .foregroundColor(bookListViewData.selectedListTab == type ? .black : .gray)
    }
}

// MARK: - PREVIEW

struct SearchTabButton_Previews: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { proxy in
            BookListTabButton(
                .bestSeller,
                scrollProxy: proxy,
                namespace: namespace
            )
            .environmentObject(BookListViewData())
        }
    }
}
