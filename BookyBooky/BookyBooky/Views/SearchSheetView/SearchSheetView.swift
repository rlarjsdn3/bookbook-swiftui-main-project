//
//  SearchSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI
import AlertToast

enum ListMode: String, CaseIterable {
    case grid = "격자 모드"
    case list = "리스트 모드"
}

struct SearchSheetView: View {
    
    // MARK: - WRAPPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @State private var searchQuery = ""
    @State private var searchIndex = 1
    @State private var selectedCategory: Category = .all
    @State private var selectedCategoryFA: Category = .all
    
    @AppStorage("SearchResultListMode") private var selectedListMode: ListMode = .list
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchSheetTextFieldView(
                    searchQuery: $searchQuery,
                    searchIndex: $searchIndex,
                    selectedListMode: $selectedListMode,
                    selectedCategory: $selectedCategory,
                    selectedCategoryFA: $selectedCategoryFA
                )
                
                SearchSheetScrollView(
                    searchQuery: $searchQuery,
                    searchIndex: $searchIndex,
                    selectedListMode: $selectedListMode,
                    selectedCategory: $selectedCategory
                )
            }
            .toast(isPresenting: $aladinAPIManager.isPresentingSearchLoadingToastAlert)  {
                aladinAPIManager.showSearchLoadingToastAlert
            }
            .toast(isPresenting: $aladinAPIManager.isPresentingSearchErrorToastAlert,
                   duration: 2.0)  {
                aladinAPIManager.showSearchErrorToastAlert
            }
            .toast(isPresenting: $aladinAPIManager.isPresentingDetailBookErrorToastAlert,
                   duration: 2.0) {
                aladinAPIManager.showDetailBookErrorToastAlert
            }
        }
        .onDisappear {
            aladinAPIManager.searchBookInfo = nil
            aladinAPIManager.searchResults.removeAll()
        }
        .presentationCornerRadius(30)
    }
}

// MARK: - PREVIEW

struct SearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetView()
            .environmentObject(AladinAPIManager())
    }
}
