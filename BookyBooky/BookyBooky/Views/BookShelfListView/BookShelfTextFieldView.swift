//
//  FavoriteBooksTextFieldView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/10.
//

import SwiftUI

struct BookShelfTextFieldView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState var focusedField: Bool
    
    // MARK: - PROPERTIES
    
    @Binding var inputQuery: String
    @Binding var searchQuery: String
    @Binding var selectedSort: BookSortCriteria
    @Binding var isPresentingShowAllButton: Bool
    let scrollProxy: ScrollViewProxy
    
    // MARK: - INTALIZER
    
    init(inputQuery: Binding<String>,
         searchQuery: Binding<String>,
         selectedSort: Binding<BookSortCriteria>,
         isPresentingShowAllButton: Binding<Bool>,
         scrollProxy: ScrollViewProxy) {
        self._inputQuery = inputQuery
        self._searchQuery = searchQuery
        self._selectedSort = selectedSort
        self._isPresentingShowAllButton = isPresentingShowAllButton
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        textFieldArea
    }
}

// MARK: - EXTENSIONS

extension BookShelfTextFieldView {
    var textFieldArea: some View {
        HStack {
            utilMenu
            
            inputField
            
            backButton
        }
        .padding()
    }
    
    var utilMenu: some View {
        Menu {
            Section {
                sortButtonGroup
            } header: {
                Text("도서 정렬")
            }
        } label: {
            ellipsisSFSymbolImage
        }
    }
    
    var sortButtonGroup: some View {
        ForEach(BookSortCriteria.allCases) { criteria in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 곧바로 스크롤을 제일 위로 올리고
                    scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            selectedSort = criteria
                        }
                        HapticManager.shared.impact(.rigid)
                    }
                }
            } label: {
                Text(criteria.name)
                if selectedSort == criteria {
                    Text("적용됨")
                }
            }
        }
    }
    
    var ellipsisSFSymbolImage: some View {
        Image(systemName: "ellipsis.circle")
            .font(.title2)
            .foregroundColor(.primary)
            .frame(width: 45, height: 45)
            .background(Color("Background"))
            .cornerRadius(15)
    }
    
    var checkMarkSFSymbolImage: some View {
        Image(systemName: "checkmark")
            .font(.title3)
    }
}

extension BookShelfTextFieldView {
    var inputField: some View {
        HStack {
            magnifyingGlassSFSymbolImage
            
            textField
            
            if !inputQuery.isEmpty {
                eraseButton
            }
        }
        .padding(.horizontal, 10)
        .background(Color("Background"))
        .cornerRadius(15)
    }
    
    var magnifyingGlassSFSymbolImage: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
    }
    
    var textField: some View {
        TextField("제목 / 저자 검색", text: $inputQuery)
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
                            searchQuery = inputQuery
                            if !inputQuery.isEmpty {
                                isPresentingShowAllButton = true
                            } else {
                                isPresentingShowAllButton = false
                            }
                        }
                        HapticManager.shared.impact(.rigid)
                    }
                }
            }
            .focused($focusedField)
    }
    
    var eraseButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                inputQuery.removeAll()
                searchQuery.removeAll()
                focusedField = true
                isPresentingShowAllButton = false
            }
        } label: {
            xmarkCircleSFSymbolsImage
        }
    }
    
    var xmarkCircleSFSymbolsImage: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
    }
}

extension BookShelfTextFieldView {
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            xmarkSFSymbolsImage
        }
    }
    
    var xmarkSFSymbolsImage: some View {
        Image(systemName: "xmark")
            .font(.title2)
            .foregroundColor(.primary)
            .frame(width: 45, height: 45)
            .background(Color("Background"))
            .cornerRadius(15)
    }
}

// MARK: - PREVIEW

struct BookShelfTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            BookShelfTextFieldView(
                inputQuery: .constant(""),
                searchQuery: .constant(""),
                selectedSort: .constant(.titleAscendingOrder),
                isPresentingShowAllButton: .constant(false),
                scrollProxy: scrollProxy
            )
        }
    }
}
