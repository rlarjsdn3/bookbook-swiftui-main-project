//
//  SearchSheetTextFieldView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI
import AlertToast

struct SearchSheetTextFieldView: View {
    
    
    
    // MARK: - PROPERTIES
    
    @Binding var searchQuery: String            // 검색어를 저장하는 변수
    @Binding var startIndex: Int                // 검색 결과 시작페이지를 저장하는 변수, 새로운 검색을 시도하는지 안하는지 판별하는 변수
    @Binding var selectedCategory: Category     // 선택된 카테고리 정보를 저장하는 변수 (검색 결과 출력용)
    @Binding var categoryAnimation: Category    // 카테고리 애니메이션 효과를 위한 변수
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @FocusState var focusedField: Bool
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            textFieldArea
            
            searchButton
        }
        // 검색 시트가 나타난 후, 0.05초 뒤에 키보드를 보이게 합니다.
        .onAppear {
            if aladinAPIManager.bookSearchItems.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    focusedField = true
                }
            }
        }
        .padding([.leading, .top, .trailing])
        .padding(.bottom, 5)
    }
}

// MARK: - EXTENSIONS

extension SearchSheetTextFieldView {
    var textFieldArea: some View {
        HStack {
            searchImage
            
            searchTextField
            
            if !searchQuery.isEmpty {
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
                requestBookSearch()
            }
            .focused($focusedField)
    }
    
    var xmarkButton: some View {
        Button {
            searchQuery.removeAll()
            focusedField = true
        } label: {
            xmarkImage
        }
    }
    
    var xmarkImage: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
    }
    
    var searchButton: some View {
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

extension SearchSheetTextFieldView {
    func requestBookSearch() {
        startIndex = 0
        // 새로운 검색 시도 시, 스크롤을 제일 위로 올립니다.
        // startIndex 변수값을 짧은 시간에 변경(0→1)함으로써 onChange 제어자가 이를 알아차려 스크롤을 위로 올립니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            startIndex = 1
        }
        
        aladinAPIManager.requestBookSearchAPI(query: searchQuery)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            categoryAnimation = .all
        }
        selectedCategory = .all
        HapticManager.shared.impact(.rigid)
    }
}

// MARK: - PREVIEW

struct SearchSheetTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetTextFieldView(
            searchQuery: .constant(""),
            startIndex: .constant(0),
            selectedCategory: .constant(.all),
            categoryAnimation: .constant(.all)
        )
        .environmentObject(AladinAPIManager())
    }
}
