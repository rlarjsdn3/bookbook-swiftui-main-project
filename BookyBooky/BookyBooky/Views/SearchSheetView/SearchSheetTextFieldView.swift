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
    
    @FocusState var focusedField: Bool
    
    // MARK: - PROPERTIES
    
    @Binding var searchQuery: String
    @Binding var searchIndex: Int
    @Binding var selectedListMode: ListMode
    @Binding var selectedCategory: CategoryType
    @Binding var selectedCategoryForAnimation: CategoryType
    
    // MARK: - BODY
    
    var body: some View {
        searchSheetTextField
            // 검색 시트가 나타난 후, 0.05초 뒤에 키보드를 보이게 합니다.
            .onAppear {
                if aladinAPIManager.searchResults.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        focusedField = true
                    }
                }
            }
            .padding([.leading, .top, .trailing])
            .padding(.bottom, 5)
    }
    
    func requestBookSearch(_ searchQuery: String) {
        searchIndex = 0
        // 새로운 검색 시도 시, 스크롤을 제일 위로 올립니다.
        // searchIndex 변수값을 짧은 시간에 변경(0→1)함으로써 onChange 제어자가 이를 알아차려 스크롤을 위로 올립니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            searchIndex = 1
        }
        aladinAPIManager.requestBookSearchAPI(searchQuery)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            selectedCategoryForAnimation = .all
        }
        selectedCategory = .all
        HapticManager.shared.impact(.rigid)
    }
}

// MARK: - EXTENSIONS

extension SearchSheetTextFieldView {
    var searchSheetTextField: some View {
        HStack {
            Menu {
                Section {
                    Button {
                        selectedListMode = .grid
                    } label: {
                        Label("격자 모드", systemImage: "square.grid.2x2")
                        if selectedListMode == .grid {
                            Text("적용됨")
                        }
                    }
                    
                    Button {
                        selectedListMode = .list
                    } label: {
                        Label("리스트 모드", systemImage: "list.dash")
                        if selectedListMode == .list {
                            Text("적용됨")
                        }
                    }
                } header: {
                    Text("보기 모드")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .frame(width: 45, height: 45)
                    .background(Color(.background), in: .rect(cornerRadius: 15))
            }

            
            searchTextField
            
            dismissButton
        }
    }
    
    var searchTextField: some View {
        HStack {
            magnifyingGlassSFSymbolImage
            
            searchInputField
            
            if !searchQuery.isEmpty {
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
    
    var searchInputField: some View {
        TextField("제목 / 저자 검색", text: $searchQuery)
            .frame(height: 45)
            .submitLabel(.search)
            .onSubmit {
                requestBookSearch(searchQuery)
            }
            .focused($focusedField)
    }
    
    var eraseButton: some View {
        Button {
            searchQuery.removeAll()
            focusedField = true
        } label: {
            xmarkCircleSFSymbolImage
        }
    }
    
    var xmarkCircleSFSymbolImage: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
    }
    
    var dismissButton: some View {
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
}

// MARK: - PREVIEW

struct SearchSheetTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetTextFieldView(
            searchQuery: .constant(""),
            searchIndex: .constant(0),
            selectedListMode: .constant(.list),
            selectedCategory: .constant(.all),
            selectedCategoryForAnimation: .constant(.all)
        )
        .environmentObject(AladinAPIManager())
    }
}
