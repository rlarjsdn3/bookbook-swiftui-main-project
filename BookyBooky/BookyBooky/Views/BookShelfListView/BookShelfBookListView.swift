//
//  FavoriteBooksView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/09.
//

import SwiftUI
import AlertToast
import RealmSwift

enum BookShelfListViewType {
    case favorite
    case complete
}

// 이름 바꿀 필요 있음
struct BookShelfListView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var selectedSort = BookSortCriteriaType.latestOrder
    @State private var inputQuery = ""
    @State private var searchQuery = ""
    
    
    @State var isPresentingShowAllButton = false
    
    @FocusState var focusedField: Bool
    
    // MARK: - PROPERTIES
    
    let viewType: BookShelfListViewType
    
    // MARK: - INTAILIZER
    
    init(viewType: BookShelfListViewType) {
        self.viewType = viewType
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                VStack {
                    BookShelfTextFieldView(
                        inputQuery: $inputQuery,
                        searchQuery: $searchQuery,
                        selectedSortType: $selectedSort,
                        isPresentingShowAllButton: $isPresentingShowAllButton,
                        scrollProxy: scrollProxy
                    )
                    
                    BookShelfListScrollView(
                        searchQuery: $searchQuery,
                        selectedSortType: $selectedSort,
                        viewType: viewType
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
            seeAllLabel
        }
        .offset(y: isPresentingShowAllButton ? -20 : 200)
    }
    
    var seeAllLabel: some View {
        Text("모두 보기")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .padding(.vertical, 10)
            .padding(.horizontal, 25)
            .background(.gray.opacity(0.2))
            .cornerRadius(25)
    }
}

// MARK: - PREVIEWS

struct FavoriteBooksView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfListView(viewType: .favorite)
    }
}
