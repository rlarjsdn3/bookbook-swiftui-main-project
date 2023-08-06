//
//  FavoriteBooksView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/09.
//

import SwiftUI
import AlertToast
import RealmSwift

struct BookShelfListView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @StateObject var bookShelfBookListViewData = BookShelfBookListViewData()
    
    // MARK: - PROPERTIES
    
    let type: ListType.BookShelfList
    
    // MARK: - INTAILIZER
    
    init(type: ListType.BookShelfList) {
        self.type = type
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    BookShelfListTextFieldView(scrollProxy: proxy)
                    
                    BookShelfListScrollView(type: type)
                }
                .overlay(alignment: .bottom) {
                    seeAllButton
                }
                .environmentObject(bookShelfBookListViewData)
            }
        }
        .presentationCornerRadius(30)
    }
}

// MARK: - EXTENSIONS

extension BookShelfListView {
    var seeAllButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                bookShelfBookListViewData.inputQuery.removeAll()
                bookShelfBookListViewData.searchQuery.removeAll()
                bookShelfBookListViewData.isPresentingShowAllButton = false
            }
        } label: {
            seeAllText
        }
        .offset(y: bookShelfBookListViewData.isPresentingShowAllButton ? -20 : 200)
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

// MARK: - PREVIEWS

struct BookShelfListView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfListView(type: .favorite)
    }
}
