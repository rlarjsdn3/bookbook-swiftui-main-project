//
//  SearchSheetTextFieldView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchSheetTextFieldView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var searchQuery: String
    @Binding var startIndex: Int
    @Binding var selectedCategory: Category
    @Binding var categoryAnimation: Category
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("제목 / 저자 검색", text: $searchQuery)
                    .frame(height: 45)
                    .submitLabel(.search)
                    .onSubmit {
                        requestBookSearch()
                    }
                
                if !searchQuery.isEmpty {
                    Button {
                        searchQuery.removeAll()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 10)
            .background(Color("Background"))
            .cornerRadius(15)
            .padding(.leading)
            
            Button {
                requestBookSearch()
            } label: {
                Text("검색")
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
    
    func requestBookSearch() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            categoryAnimation = .all
        }
        selectedCategory = .all
        
        startIndex = 1 
        bookViewModel.requestBookSearchAPI(query: searchQuery)
        
    }
}

struct SearchSheetTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetTextFieldView(
            searchQuery: .constant(""),
            startIndex: .constant(0),
            selectedCategory: .constant(.all),
            categoryAnimation: .constant(.all)
        )
        .environmentObject(BookViewModel())
    }
}
