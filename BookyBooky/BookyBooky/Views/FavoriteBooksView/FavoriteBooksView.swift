//
//  FavoriteBooksView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/09.
//

import SwiftUI
import RealmSwift

struct FavoriteBooksView: View {
    
    let coulmns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var selectedSort: SortBy = .latestOrder
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState var focusedField: Bool
    @State private var searchQuery = ""
    
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

            ScrollView {
                LazyVGrid(columns: coulmns) {
                    ForEach(sortedFavoritesBooks) { favoriteBook in
                        FavoriteBookCellView(favoriteBook: favoriteBook)
                    }
                }
            }
            .padding(.horizontal, 10)
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
        TextField("제목 / 저자 검색", text: $searchQuery)
            .frame(height: 45)
            .submitLabel(.search)
            .onSubmit {
                
            }
            .focused($focusedField)
    }
    
    var xmarkButton: some View {
        Button {
            searchQuery.removeAll()
            focusedField = true
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
}

struct FavoriteBooksView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteBooksView()
    }
}
