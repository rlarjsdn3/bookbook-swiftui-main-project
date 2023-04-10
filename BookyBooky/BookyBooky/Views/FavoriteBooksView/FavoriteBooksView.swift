//
//  FavoriteBooksView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/09.
//

import SwiftUI
import AlertToast
import RealmSwift

struct FavoriteBooksView: View {
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedSort = SortBy.latestOrder
    @State private var searchQuery = ""
    @State var isPresentingShowAll = false
    
    @FocusState var focusedField: Bool
    
    // MARK: - BODY
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            VStack {
                FavoriteBooksTextFieldView(
                    selectedSort: $selectedSort,
                    query: $searchQuery,
                    isPresentingShowAll: $isPresentingShowAll,
                    scrollProxy: scrollProxy
                )

                FavoriteBooksScrollView(
                    selectedSort: $selectedSort,
                    searchQuery: $searchQuery
                )
            }
            .overlay(alignment: .bottom) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            searchQuery.removeAll()
                            isPresentingShowAll = false
                        }
                    } label: {
                        Text("모두 보기")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(25)
                    }
                    .offset(y: isPresentingShowAll ? -20 : 100)
            }
            .presentationCornerRadius(30)
        }
    }
}

// MARK: - EXTENSIONS

extension FavoriteBooksView {
    
}

// MARK: - PREVIEWS

struct FavoriteBooksView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteBooksView()
    }
}
