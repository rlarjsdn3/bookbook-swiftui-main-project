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
    
    // 찜하기 삭제 시, 뷰의 애니메이션이 안 끊기게 하기 위해 선언
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var selectedSort = BookSort.latestOrder
    @State private var searchQuery = ""
    @State var isPresentingShowAll = false
    
    @FocusState var focusedField: Bool
    
    // MARK: - BODY
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            VStack {
                FavoriteBooksTextFieldView(
                    selectedSort: $selectedSort,
                    searchQuery: $searchQuery,
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
