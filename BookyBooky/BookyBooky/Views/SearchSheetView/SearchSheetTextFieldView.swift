//
//  SearchSheetTextFieldView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI
import AlertToast

struct SearchSheetTextFieldView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var searchSheetViewData: SearchSheetViewData
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    @EnvironmentObject var alertManager: AlertManager
    
    @Namespace var namespace: Namespace.ID
    
    @FocusState var focusedField: Bool
    
    @State private var bookCategories: [Category] = []
    
    // MARK: - PROPERTIES
    
    let haptic = HapticManager()
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 10) {
            TextFieldArea
            
            categoryArea
        }
        .onAppear {
            if searchSheetViewData.bookSearchResult.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focusedField = true
                }
            }
        }
        .onChange(of: searchSheetViewData.bookSearchResult) { _ in
            bookCategories = getCategory(searchSheetViewData.bookSearchResult)
        }
    }
    
    func requestSearchBook(_ query: String) {
        searchSheetViewData.searchIndex = 0
        alertManager.isPresentingSearchLoadingToastAlert = true
        // 새로운 검색 시도 시, 스크롤을 제일 위로 올립니다.
        // searchIndex 변수값을 짧은 시간에 변경(0→1)함으로써 onChange 제어자가 이를 알아차려 스크롤을 위로 올립니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            searchSheetViewData.searchIndex = 1
        }
        aladinAPIManager.requestBookSearchResult(query) { book in
            DispatchQueue.main.async {
                if let book = book {
                    searchSheetViewData.bookSearchResult = book.item
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        alertManager.isPresentingSearchLoadingToastAlert = false
                    }
                } else {
                    alertManager.isPresentingSearchLoadingToastAlert = false
                    alertManager.isPresentingDetailBookErrorToastAlert = true
                }
            }
        }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            searchSheetViewData.selectedCategoryFA = .all
        }
        searchSheetViewData.selectedCategory = .all
        haptic.impact(.rigid)
    }
    
    func getCategory(_ books: [SimpleBookInfo.Item]) -> [Category] {
        var categories: [Category] = []
        
        // 중복되지 않게 카테고리 항목 저장하기
        for book in books where !categories.contains(book.bookCategory) {
            categories.append(book.bookCategory)
        }
        // 카테고리 항목에 '기타'가 있다면
        if let index = categories.firstIndex(of: .etc) {
            categories.remove(at: index) // '기타' 항목 제거
            // 카테고리 이름을 오름차순(가, 나, 다)으로 정렬
            categories.sort {
                $0.name < $1.name
            }
            // '기타'를 제일 뒤로 보내기
            categories.append(.etc)
        } else {
            // 카테고리 이름을 오름차순(가, 나, 다)으로 정렬
            categories.sort {
                $0.name < $1.name
            }
        }
        // 카테고리의 첫 번째에 '전체' 항목 추가
        categories.insert(.all, at: 0)
        print("호출됨")
        return categories
    }
}

// MARK: - EXTENSIONS

extension SearchSheetTextFieldView {
    var TextFieldArea: some View {
        HStack {
            listModeMenu

            inputField
            
            backButton
        }
        .padding([.leading, .top, .trailing])
    }
    
    var listModeMenu: some View {
        Menu {
            Section {
                listModeButton
                
                gridModeButton
            } header: {
                Text("보기 모드")
            }
        } label: {
            epllipsisSFSymbolImage
        }
    }
    
    var listModeButton: some View {
        Button {
            searchSheetViewData.selectedListMode = .grid
        } label: {
            Label("격자 모드", systemImage: "square.grid.2x2")
            if searchSheetViewData.selectedListMode == .grid {
                Text("적용됨")
            }
        }
    }
    
    var gridModeButton: some View {
        Button {
            searchSheetViewData.selectedListMode = .list
        } label: {
            Label("리스트 모드", systemImage: "list.dash")
            if searchSheetViewData.selectedListMode == .list {
                Text("적용됨")
            }
        }
    }
    
    var epllipsisSFSymbolImage: some View {
        Image(systemName: "ellipsis.circle")
            .font(.title2)
            .foregroundColor(.primary)
            .frame(width: 45, height: 45)
            .background(Color(.background), in: .rect(cornerRadius: 15))
    }
    
    var inputField: some View {
        HStack {
            magnifyingGlassSFSymbolImage
            
            textField
            
            if !searchSheetViewData.inputQuery.isEmpty {
                eraseButton
            }
        }
        .padding(.horizontal, 10)
        .background(Color(.background), in: .rect(cornerRadius: 15))
        .cornerRadius(15)
    }
    
    var magnifyingGlassSFSymbolImage: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
    }
    
    var textField: some View {
        TextField("제목 / 저자 검색", text: $searchSheetViewData.inputQuery)
            .frame(height: 45)
            .submitLabel(.search)
            .onSubmit {
                requestSearchBook(searchSheetViewData.inputQuery)
            }
            .focused($focusedField)
    }
    
    var eraseButton: some View {
        Button {
            searchSheetViewData.inputQuery.removeAll()
            focusedField = true
        } label: {
            xmarkCircleSFSymbolImage
        }
    }
    
    var xmarkCircleSFSymbolImage: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            xmarkSFSymbolImage
        }
    }
    
    var xmarkSFSymbolImage: some View {
        Image(systemName: "xmark")
            .font(.title2)
            .foregroundColor(.primary)
            .frame(width: 45, height: 45)
            .background(Color(.background), in: .rect(cornerRadius: 15))
    }
    
    
    var categoryArea: some View {
        Group {
            if !searchSheetViewData.bookSearchResult.isEmpty {
                categoryButtonGroup
            }
        }
    }
    
    var categoryButtonGroup: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -20) {
                    ForEach(bookCategories, id: \.self) { category in
                        SearchCategoryButton(
                            category,
                            namespace: namespace,
                            scrollProxy: proxy
                        )
                        .id(category.rawValue)
                    }
                    .id("Scroll_To_Leading")
                }
            }
            .onChange(of: searchSheetViewData.searchIndex) { _ in
                // 새로운 검색을 시도할 때만 카테고리 스크롤을 제일 앞으로 전진합니다.
                // '더 보기' 버튼을 클릭해도 카테고리 스크롤이 이동하지 않습니다.
                if searchSheetViewData.searchIndex == 1 {
                    withAnimation {
                        proxy.scrollTo("Scroll_To_Leading", anchor: .top)
                    }
                }
            }
            .padding(.bottom, 8)
        }
    }    
}

// MARK: - PREVIEW

struct SearchSheetTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetTextFieldView()
            .environmentObject(SearchSheetViewData())
            .environmentObject(AladinAPIManager())
    }
}
