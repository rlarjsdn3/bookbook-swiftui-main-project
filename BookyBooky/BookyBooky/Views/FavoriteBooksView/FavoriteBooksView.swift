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
    
    let coulmns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var selectedSort = SortBy.latestOrder
    @State private var searchQuery = ""
    @State private var query = ""
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState var focusedField: Bool
    
    @State var previousFavoriteBooks: [FavoriteBook] = []
    @State var isPresentingShowAll = false
    
    var sortedFavoritesBooks: [FavoriteBook] {
        switch selectedSort {
        // 최근 추가된 순으로 정렬
        case .latestOrder:
            return favoriteBooks.reversed()
        // 제목 오름차순으로 정렬
        case .titleOrder:
            return favoriteBooks.sorted { $0.title < $1.title }
        // 판매 포인트 내림차순으로 정렬
        case .sellingPointOrder:
            return favoriteBooks.sorted { $0.salesPoint.toInteger > $1.salesPoint.toInteger }
        }
    }
    
    var filteredFavroriteBooks: [FavoriteBook] {
        if !searchQuery.isEmpty {
            let filteredFavoriteBooks = sortedFavoritesBooks.filter {
                $0.title.contains(searchQuery) || $0.author.contains(searchQuery)
            }
            return filteredFavoriteBooks
        } else {
            return sortedFavoritesBooks
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Menu {
                    Section {
                        ForEach(SortBy.allCases, id: \.self) { sort in
                            Button {
                                selectedSort = sort
                            } label: {
                                HStack {
                                    Text(sort.rawValue)
                                    
                                    if selectedSort == sort {
                                        Image(systemName: "checkmark")
                                            .font(.title3)
                                    }
                                }
                            }
                            
                        }
                    } header: {
                        Text("도서 정렬")
                    }

                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(width: 45, height: 45)
                        .background(Color("Background"))
                        .cornerRadius(15)
                }
                
                textFieldArea
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(width: 45, height: 45)
                        .background(Color("Background"))
                        .cornerRadius(15)
                }
            }
            .padding()

            if !filteredFavroriteBooks.isEmpty {
                ScrollView {
                    LazyVGrid(columns: coulmns) {
                        ForEach(filteredFavroriteBooks) { favoriteBook in
                            FavoriteBookCellView(favoriteBook: favoriteBook)
                        }
                    }
                }
                .padding(.horizontal, 10)
            } else {
                noResultLabel
            }
        }
        .overlay(alignment: .bottom) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    searchQuery.removeAll()
                    query.removeAll()
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

extension FavoriteBooksView {
    var textFieldArea: some View {
        HStack {
            searchImage
            
            searchTextField
            
            if !searchQuery.isEmpty {
                xmarkButton
            }
        }
        .padding(.horizontal, 10)
        .background(Color("Background"))
        .cornerRadius(15)
    }
    
    var searchImage: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
    }
    
    var searchTextField: some View {
        TextField("제목 / 저자 검색", text: $query)
            .frame(height: 45)
            .submitLabel(.search)
            .onSubmit {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    searchQuery = query
                    if !searchQuery.isEmpty {
                        isPresentingShowAll = true
                    } else {
                        isPresentingShowAll = false
                    }
                }
            }
            .focused($focusedField)
    }
    
    var xmarkButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                searchQuery.removeAll()
                query.removeAll()
                focusedField = true
                isPresentingShowAll = false
            }
        } label: {
            xmarkImage
        }
    }
    
    var xmarkImage: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
    }
    
    var searchButton: some View {
        Button {
            hideKeyboard()
        } label: {
            Text("검색")
        }
        .padding(.horizontal)
    }
    
    var noResultLabel: some View {
        VStack {
            VStack {
                Text("결과 없음")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxHeight: .infinity)
                
                Text("새로운 검색을 시도하십시오.")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .frame(height: 50)
        }
        .frame(maxHeight: .infinity)
    }
}

struct FavoriteBooksView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteBooksView()
    }
}
