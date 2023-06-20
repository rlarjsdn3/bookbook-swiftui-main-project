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
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @Namespace var namespace: Namespace.ID
    
    @FocusState var focusedField: Bool
    
    // MARK: - PROPERTIES
    
    @Binding var inputQuery: String
    @Binding var searchIndex: Int
    @Binding var selectedListMode: ListMode
    @Binding var selectedCategory: Category
    @Binding var selectedCategoryFA: Category
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 10) {
            TextFieldArea
            
            searchCategory
        }
        .onAppear {
            if aladinAPIManager.searchResults.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focusedField = true
                }
            }
        }
    }
    
    func requestSearchBook(_ query: String) {
        searchIndex = 0
        // 새로운 검색 시도 시, 스크롤을 제일 위로 올립니다.
        // searchIndex 변수값을 짧은 시간에 변경(0→1)함으로써 onChange 제어자가 이를 알아차려 스크롤을 위로 올립니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            searchIndex = 1
        }
        aladinAPIManager.requestBookSearchAPI(query)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            selectedCategoryFA = .all
        }
        selectedCategory = .all
        HapticManager.shared.impact(.rigid)
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
            selectedListMode = .grid
        } label: {
            Label("격자 모드", systemImage: "square.grid.2x2")
            if selectedListMode == .grid {
                Text("적용됨")
            }
        }
    }
    
    var gridModeButton: some View {
        Button {
            selectedListMode = .list
        } label: {
            Label("리스트 모드", systemImage: "list.dash")
            if selectedListMode == .list {
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
            
            if !inputQuery.isEmpty {
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
        TextField("제목 / 저자 검색", text: $inputQuery)
            .frame(height: 45)
            .submitLabel(.search)
            .onSubmit {
                requestSearchBook(inputQuery)
            }
            .focused($focusedField)
    }
    
    var eraseButton: some View {
        Button {
            inputQuery.removeAll()
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
    
    
    var searchCategory: some View {
        Group {
            if aladinAPIManager.searchResults.isEmpty {
                EmptyView()
            } else {
                categoryButtonGroup
            }
        }
    }
    
    var categoryButtonGroup: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                scrollCategoryButton(scrollProxy: proxy)
            }
            .onChange(of: searchIndex) {
                // 새로운 검색을 시도할 때만 카테고리 스크롤을 제일 앞으로 전진합니다.
                // '더 보기' 버튼을 클릭해도 카테고리 스크롤이 이동하지 않습니다.
                if searchIndex == 1 {
                    withAnimation {
                        proxy.scrollTo("Scroll_To_Leading", anchor: .top)
                    }
                }
            }
            .padding(.bottom, 8)
        }
    }
    
    func scrollCategoryButton(scrollProxy proxy: ScrollViewProxy) -> some View {
        HStack(spacing: -20) {
            ForEach(aladinAPIManager.categories, id: \.self) { type in
                SearchCategoryButton(
                    type,
                    selectedCategory: $selectedCategory,
                    selectedCategoryForAnimation: $selectedCategoryFA,
                    namespace: namespace,
                    scrollProxy: proxy
                )
                .id(type.rawValue)
            }
            .id("Scroll_To_Leading")
        }
    }
    
}

// MARK: - PREVIEW

struct SearchSheetTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetTextFieldView(
            inputQuery: .constant(""),
            searchIndex: .constant(0),
            selectedListMode: .constant(.list),
            selectedCategory: .constant(.all),
            selectedCategoryFA: .constant(.all)
        )
        .environmentObject(AladinAPIManager())
    }
}
