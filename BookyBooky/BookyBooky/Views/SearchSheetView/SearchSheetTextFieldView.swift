//
//  SearchSheetTextFieldView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchSheetTextFieldView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var searchQuery: String
    @Binding var startIndex: Int
    @Binding var selectedCategory: Category
    @Binding var categoryAnimation: Category
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: BookViewModel
    @FocusState var focusedField: Bool
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            textFieldArea
            
            searchButton
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focusedField = true
            }
        }
        .padding(.top)
    }
}

// MARK: - EXTENSIONS

extension SearchSheetTextFieldView {
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
        .padding(.leading)
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
                requestBookSearch()
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
            requestBookSearch()
            hideKeyboard()
        } label: {
            Text("검색")
        }
        .disabled(searchQuery.isEmpty)
        .padding(.horizontal)
    }
}

extension SearchSheetTextFieldView {
    func requestBookSearch() {
        startIndex = 1
        bookViewModel.requestBookSearchAPI(query: searchQuery)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            categoryAnimation = .all
        }
        selectedCategory = .all
        Haptics.shared.play(.rigid)
    }
}

// MARK: - PREVIEW

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
