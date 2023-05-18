//
//  FavoriteBooksTextFieldView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/10.
//

import SwiftUI

struct FavoriteBooksTextFieldView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var selectedSort: BookSortCriteriaTypes
    @Binding var searchWord: String
    @Binding var searchQuery: String
    @Binding var isPresentingShowAll: Bool
    let scrollProxy: ScrollViewProxy
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState var focusedField: Bool
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            sortMenu
            
            textField
            
            dismissButton
        }
        .padding()
    }
}

// MARK: - EXTENSIONS

extension FavoriteBooksTextFieldView {
    var sortMenu: some View {
        Menu {
            Section {
                sortButtons
            } header: {
                Text("도서 정렬")
            }
        } label: {
            ellipsis
        }
    }
    
    var sortButtons: some View {
        ForEach(BookSortCriteriaTypes.allCases, id: \.self) { sort in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 곧바로 스크롤을 제일 위로 올리고
                    scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            selectedSort = sort
                        }
                        HapticManager.shared.impact(.rigid)
                    }
                }
            } label: {
                HStack {
                    Text(sort.rawValue)
                    
                    // 현재 선택한 정렬 타입에 체크마크 표시
                    if selectedSort == sort {
                        checkmark
                    }
                }
            }
        }
    }
    
    var ellipsis: some View {
        Image(systemName: "ellipsis.circle")
            .font(.title2)
            .foregroundColor(.primary)
            .frame(width: 45, height: 45)
            .background(Color("Background"))
            .cornerRadius(15)
    }
    
    var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.title3)
    }
}

extension FavoriteBooksTextFieldView {
    var textField: some View {
        HStack {
            magnifyingglass
            
            searchField
            
            if !searchWord.isEmpty {
                xmarkButton
            }
        }
        .padding(.horizontal, 10)
        .background(Color("Background"))
        .cornerRadius(15)
    }
    
    var magnifyingglass: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
    }
    
    var searchField: some View {
        TextField("제목 / 저자 검색", text: $searchWord)
            .frame(height: 45)
            .submitLabel(.search)
            .onSubmit {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 곧바로 스크롤을 제일 위로 올리고
                    scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            searchQuery = searchWord
                            if !searchWord.isEmpty {
                                isPresentingShowAll = true
                            } else {
                                isPresentingShowAll = false
                            }
                        }
                        HapticManager.shared.impact(.rigid)
                    }
                }
            }
            .focused($focusedField)
    }
    
    var xmarkButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                searchWord.removeAll()
                searchQuery.removeAll()
                focusedField = true
                isPresentingShowAll = false
            }
        } label: {
            xmarkCircleFill
        }
    }
    
    var xmarkCircleFill: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
    }
}

extension FavoriteBooksTextFieldView {
    var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            xmark
        }
    }
    
    var xmark: some View {
        Image(systemName: "xmark")
            .font(.title2)
            .foregroundColor(.primary)
            .frame(width: 45, height: 45)
            .background(Color("Background"))
            .cornerRadius(15)
    }
}

// MARK: - PREVIEW

struct FavoriteBooksTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            FavoriteBooksTextFieldView(
                selectedSort: .constant(.latestOrder),
                searchWord: .constant(""),
                searchQuery: .constant(""),
                isPresentingShowAll: .constant(false),
                scrollProxy: scrollProxy
            )
        }
    }
}
