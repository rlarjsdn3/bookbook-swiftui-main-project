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
    @Binding var selectedSortType: BookSortCriteriaType
    @Binding var isPresentingShowAllButton: Bool
    let scrollProxy: ScrollViewProxy
    
    // MARK: - INTALIZER
    
    init(inputQuery: Binding<String>, searchQuery: Binding<String>,
         selectedSortType: Binding<BookSortCriteriaType>, isPresentingShowAllButton: Binding<Bool>,
         scrollProxy: ScrollViewProxy) {
        self._inputQuery = inputQuery
        self._searchQuery = searchQuery
        self._selectedSortType = selectedSortType
        self._isPresentingShowAllButton = isPresentingShowAllButton
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookTextField
    }
}

// MARK: - EXTENSIONS

extension FavoriteBooksTextFieldView {
    var bookTextField: some View {
        HStack {
            bookSortMenu
            
            searchTextField
            
            dismissButton
        }
        .padding()
    }
    
    var bookSortMenu: some View {
        Menu {
            Section {
                sortButtons
            } header: {
                Text("도서 정렬")
            }
        } label: {
            ellipsisSFSymbolImage
        }
    }
    
    var sortButtons: some View {
        ForEach(BookSortCriteriaType.allCases, id: \.self) { sort in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 곧바로 스크롤을 제일 위로 올리고
                    scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            selectedSortType = sort
                        }
                        HapticManager.shared.impact(.rigid)
                    }
                }
            } label: {
                HStack {
                    Text(sort.rawValue)
                    
                    // 현재 선택한 정렬 타입에 체크마크 표시
                    if selectedSortType == sort {
                        checkMarkSFSymbolImage
                    }
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

extension FavoriteBooksTextFieldView {
    var searchTextField: some View {
        HStack {
            magnifyingGlassSFSymbolImage
            
            searchInputField
            
            if !inputQuery.isEmpty {
                inputEraseButton
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
    
    var searchInputField: some View {
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
    
    var inputEraseButton: some View {
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

extension FavoriteBooksTextFieldView {
    var dismissButton: some View {
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
                selectedSortType: .constant(.latestOrder),
                isPresentingShowAllButton: .constant(false),
                scrollProxy: scrollProxy
            )
        }
    }
}
