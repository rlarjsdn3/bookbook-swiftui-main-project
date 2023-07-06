//
//  BookShelfSentenceView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/03.
//

import SwiftUI

struct BookShelfSentenceListView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @StateObject var bookShelfSentenceListViewData = BookShelfSentenceListViewData()
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    BookShelfSentenceListTextFieldView(scrollProxy: proxy)
                    
                    BookShelfSentenceScrollView()
                }
                .environmentObject(bookShelfSentenceListViewData)
            }
            .overlay(alignment: .bottom) {
                seeAllButton
            }
        }
    }
}

// MARK: - EXTENSIONS

extension BookShelfSentenceListView {
    var seeAllButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                bookShelfSentenceListViewData.inputQuery.removeAll()
                bookShelfSentenceListViewData.searchQuery.removeAll()
                bookShelfSentenceListViewData.isPresentingShowAllButton = false
            }
        } label: {
            seeAllText
        }
        .offset(y: bookShelfSentenceListViewData.isPresentingShowAllButton ? -20 : 200)
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

#Preview {
    BookShelfSentenceListView()
}
