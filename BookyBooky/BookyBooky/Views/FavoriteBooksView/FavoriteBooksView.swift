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
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState var focusedField: Bool
    @State private var searchQuery = ""
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    
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
                    ForEach(favoriteBooks) { favoriteBook in
                        FavoriteBookCellView(favoriteBook: favoriteBook)
                    }
                }
            }
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
