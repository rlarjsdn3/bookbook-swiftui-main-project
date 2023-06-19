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
    
    @State private var inputQuery = ""
    @State private var searchQuery = ""
    @State private var selectedSort: BookSortCriteria = .titleAscendingOrder
    
    @State var isPresentingShowAllButton = false
    
    // MARK: - PROPERTIES
    
    let type: BookShelfList
    
    // MARK: - INTAILIZER
    
    init(type: BookShelfList) {
        self.type = type
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                VStack(spacing: 0) {
                    BookShelfTextFieldView(
                        inputQuery: $inputQuery,
                        searchQuery: $searchQuery,
                        selectedSort: $selectedSort,
                        isPresentingShowAllButton: $isPresentingShowAllButton,
                        scrollProxy: scrollProxy
                    )
                    
                    BookShelfListScrollView(
                        searchQuery: $searchQuery,
                        selectedSortType: $selectedSort,
                        type: type
                    )
                }
                .overlay(alignment: .bottom) {
                    seeAllButton
                }
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

// MARK: - PREVIEWS

struct FavoriteBooksView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfListView(type: .favorite)
    }
}
