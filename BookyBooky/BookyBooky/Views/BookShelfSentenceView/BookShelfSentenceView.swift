//
//  BookShelfSentenceView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/03.
//

import SwiftUI

struct BookShelfSentenceView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var inputQuery = ""
    @State private var searchQuery = ""
    @State private var selectedSort: BookSortCriteria = .titleAscendingOrder
    
    @State var isPresentingShowAllButton = false
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                VStack(spacing: 0) {
                    BookShelfSentenceTextFieldView(
                        inputQuery: $inputQuery,
                        searchQuery: $searchQuery,
                        selectedSort: $selectedSort,
                        isPresentingShowAllButton: $isPresentingShowAllButton,
                        scrollProxy: scrollProxy
                    )
                    
                    BookShelfSentenceListView(
                        searchQuery: $searchQuery,
                        selectedSort: $selectedSort
                    )
                }
            }
            .overlay(alignment: .bottom) {
                seeAllButton
            }
        }
    }
}

// MARK: - EXTENSIONS

extension BookShelfSentenceView {
    var seeAllButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                inputQuery.removeAll()
                searchQuery.removeAll()
                isPresentingShowAllButton = false
            }
        } label: {
            seeAllText
        }
        .offset(y: isPresentingShowAllButton ? -20 : 200)
    }
    
    var seeAllText: some View {
        Text("모두 보기")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(Color.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 25)
            .background(Color.black)
            .cornerRadius(25)
    }
}

struct BookShelfSentenceView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfSentenceView()
    }
}
