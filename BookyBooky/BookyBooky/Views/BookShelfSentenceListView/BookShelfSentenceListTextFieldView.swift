//
//  BookShelfSentenceTextFieldView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/03.
//

import SwiftUI
import RealmSwift

struct BookShelfSentenceListTextFieldView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var bookShelfSentenceListViewData: BookShelfSentenceListViewData
    
    @State private var isPresentingBookShelfSentenceFilterSheetView = false
    
    @FocusState var focusedField: Bool
    
    // MARK: - PROPERTIES
    
    let scrollProxy: ScrollViewProxy
    
    let haptic = HapticManager()
    
    // MARK: - INTALIZER
    
    init(scrollProxy: ScrollViewProxy) {
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        textFieldArea
    }
}

// MARK: - EXTENSIONS

extension BookShelfSentenceListTextFieldView {
    var textFieldArea: some View {
        HStack {
            bookSortMenu
            
            inputField
            
            backButton
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 2)
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
        ForEach(BookSortCriteria.allCases, id: \.self) { sort in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 곧바로 스크롤을 제일 위로 올리고
                    scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            bookShelfSentenceListViewData.selectedSort = sort
                        }
                        haptic.impact(.rigid)
                    }
                }
            } label: {
                Text(sort.name)
                if bookShelfSentenceListViewData.selectedSort == sort {
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
            .background(Color.customBackground, in: RoundedRectangle(cornerRadius: 15))
    }
    
    var checkMarkSFSymbolImage: some View {
        Image(systemName: "checkmark")
            .font(.title3)
    }
}

extension BookShelfSentenceListTextFieldView {
    var inputField: some View {
        HStack {
            magnifyingGlassSFSymbolImage
            
            textField
            
            if !bookShelfSentenceListViewData.inputQuery.isEmpty {
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
        TextField("제목 / 저자 검색", text: $bookShelfSentenceListViewData.inputQuery)
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
                            bookShelfSentenceListViewData.searchQuery = bookShelfSentenceListViewData.inputQuery
                            if bookShelfSentenceListViewData.inputQuery.isEmpty {
                                bookShelfSentenceListViewData.isPresentingShowAllButton = false
                            } else {
                                bookShelfSentenceListViewData.isPresentingShowAllButton = true
                            }
                        }
                        haptic.impact(.rigid)
                    }
                }
            }
            .focused($focusedField)
    }
    
    var eraseButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                bookShelfSentenceListViewData.inputQuery.removeAll()
                bookShelfSentenceListViewData.searchQuery.removeAll()
                bookShelfSentenceListViewData.isPresentingShowAllButton = false
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

extension BookShelfSentenceListTextFieldView {
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

struct BookShelfSentenceListTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReader { proxy in
            BookShelfSentenceListTextFieldView(scrollProxy: proxy)
                .environmentObject(BookShelfSentenceListViewData())
        }
    }
}

