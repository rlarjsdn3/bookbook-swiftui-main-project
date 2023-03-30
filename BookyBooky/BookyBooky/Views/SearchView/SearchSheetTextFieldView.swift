//
//  SearchSheetTextFieldView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchSheetTextFieldView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    
    @Binding var query: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("제목 / 저자 검색", text: $query)
                    .frame(height: 45)
                    .submitLabel(.search)
                    .onSubmit {
                        requestBookSearch(query: query)
                    }
                
                if !query.isEmpty {
                    Button {
                        query = ""
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
                requestBookSearch(query: query)
            } label: {
                Text("검색")
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
    
    func requestBookSearch(query: String) {
        bookViewModel.requestBookSearchAPI(search: query)
        self.query = ""
    }
}

struct SearchSheetTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetTextFieldView(query: .constant(""))
            .environmentObject(BookViewModel())
    }
}
