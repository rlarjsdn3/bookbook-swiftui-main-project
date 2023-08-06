//
//  FavoriteBooksTextFieldView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/10.
//

import SwiftUI

struct BookShelfListTextFieldView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var bookShelfBookListViewData: BookShelfBookListViewData
    
    @FocusState var focusedField: Bool
    
    // MARK: - PROPERTIES
    
    let haptic = HapticManager()
    
    let scrollProxy: ScrollViewProxy
    
    // MARK: - INTALIZER
    
    init(scrollProxy: ScrollViewProxy) {
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        textFieldArea
    }
    
    func submitAction() {
        // 버튼을 클릭하면
        withAnimation(.spring()) {
            // 곧바로 스크롤을 제일 위로 올리고
            scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
            // 0.3초 대기 후, 정렬 애니메이션 수행
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    bookShelfBookListViewData.searchQuery = bookShelfBookListViewData.inputQuery
                    if !bookShelfBookListViewData.inputQuery.isEmpty {
                        bookShelfBookListViewData.isPresentingShowAllButton = true
                    } else {
                        bookShelfBookListViewData.isPresentingShowAllButton = false
                    }
                }
                haptic.impact(.rigid)
            }
        }
    }
}

// MARK: - EXTENSIONS

extension BookShelfListTextFieldView {
    var textFieldArea: some View {
        HStack {
            bookSortMenu
            
            inputField
            
            backButton
        }
        .padding()
    }
    
    var bookSortMenu: some View {
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
                            bookShelfBookListViewData.selectedSort = criteria
                        }
                        haptic.impact(.rigid)
                    }
                }
            } label: {
                Text(criteria.name)
                if bookShelfBookListViewData.selectedSort == criteria {
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

extension BookShelfListTextFieldView {
    var inputField: some View {
        HStack {
            magnifyingGlassSFSymbolImage
            
            textField
            
            if !bookShelfBookListViewData.inputQuery.isEmpty {
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
        TextField("제목 / 저자 검색", text: $bookShelfBookListViewData.inputQuery)
            .frame(height: 45)
            .submitLabel(.search)
            .onSubmit(submitAction)
            .focused($focusedField)
    }
    
    var eraseButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                bookShelfBookListViewData.inputQuery.removeAll()
                bookShelfBookListViewData.searchQuery.removeAll()
                bookShelfBookListViewData.isPresentingShowAllButton = false
                focusedField = true
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

extension BookShelfListTextFieldView {
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

struct BookShelfListTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReader { proxy in
            BookShelfListTextFieldView(scrollProxy: proxy)
        }
    }
}
