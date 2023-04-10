//
//  FavoriteBooksTextFieldView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/10.
//

import SwiftUI

struct FavoriteBooksTextFieldView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedSort: SortBy
    @Binding var query: String
    @Binding var isPresentingShowAll: Bool
    
    let scrollProxy: ScrollViewProxy
    
    @State private var searchQuery = ""
    
    @FocusState var focusedField: Bool
    
    var body: some View {
        HStack {
            Menu {
                Section {
                    ForEach(SortBy.allCases, id: \.self) { sort in
                        Button {
                            withAnimation(.spring()) {
                                scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                        selectedSort = sort
                                    }
                                }
                            }
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
    }
}

extension FavoriteBooksTextFieldView {
    var textFieldArea: some View {
        HStack {
            searchImage
            
            searchTextField
            
            if !query.isEmpty {
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
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    query = searchQuery
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
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
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
}

struct FavoriteBooksTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            FavoriteBooksTextFieldView(
                selectedSort: .constant(.latestOrder),
                query: .constant(""),
                isPresentingShowAll: .constant(false),
                scrollProxy: scrollProxy
            )
        }
    }
}
