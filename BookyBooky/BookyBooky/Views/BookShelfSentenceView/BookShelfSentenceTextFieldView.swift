//
//  BookShelfSentenceTextFieldView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/03.
//

import SwiftUI
import RealmSwift

enum SentenceSortCriteriaType: String, CaseIterable {
    case titleAscending = "제목 오름차순"
    case titleDescending = "제목 내림차순"
}

struct BookShelfSentenceTextFieldView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isPresentingBookShelfSentenceFilterSheetView = false
    
    @FocusState var focusedField: Bool
    
    // MARK: - PROPERTIES
    
    @Binding var inputQuery: String
    @Binding var searchQuery: String
    @Binding var selectedSortType: SentenceSortCriteriaType
    @Binding var selectedFilter: [String]
    @Binding var isPresentingShowAllButton: Bool
    let scrollProxy: ScrollViewProxy
    
    // MARK: - INTALIZER
    
    init(inputQuery: Binding<String>, searchQuery: Binding<String>,
         selectedSortType: Binding<SentenceSortCriteriaType>, selectedFilter: Binding<[String]>,
         isPresentingShowAllButton: Binding<Bool>, scrollProxy: ScrollViewProxy) {
        self._inputQuery = inputQuery
        self._searchQuery = searchQuery
        self._selectedSortType = selectedSortType
        self._selectedFilter = selectedFilter
        self._isPresentingShowAllButton = isPresentingShowAllButton
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookShelfTextField
            .sheet(isPresented: $isPresentingBookShelfSentenceFilterSheetView) {
                BookShelfSentenceFilterSheetView(selectedFilterBook: $selectedFilter)
            }
    }
}

// MARK: - EXTENSIONS

extension BookShelfSentenceTextFieldView {
    var bookShelfTextField: some View {
        HStack {
            bookSortMenu
            
            searchTextField
            
            dismissButton
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 2)
    }
    
    var bookSortMenu: some View {
        Menu {
            Section {
                sortButtons
                
                Divider()
                
                Button {
                    isPresentingBookShelfSentenceFilterSheetView = true
                } label: {
                    Label("도서 필터링", systemImage: "line.3.horizontal.decrease.circle")
                }
            } header: {
                Text("도서 정렬")
            }
        } label: {
            ellipsisSFSymbolImage
        }
    }
    
    var sortButtons: some View {
        ForEach(SentenceSortCriteriaType.allCases, id: \.self) { sort in
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

extension BookShelfSentenceTextFieldView {
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
                            if inputQuery.isEmpty {
                                isPresentingShowAllButton = false
                            } else {
                                isPresentingShowAllButton = true
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

extension BookShelfSentenceTextFieldView {
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

struct BookShelfSentenceTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            BookShelfSentenceTextFieldView(
                inputQuery: .constant(""),
                searchQuery: .constant(""),
                selectedSortType: .constant(.titleAscending),
                selectedFilter: .constant([""]),
                isPresentingShowAllButton: .constant(false),
                scrollProxy: scrollProxy
            )
        }
    }
}

