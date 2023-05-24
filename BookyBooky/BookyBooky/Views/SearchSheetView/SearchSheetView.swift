//
//  SearchSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI
import AlertToast

struct SearchSheetView: View {
    
    // MARK: - WRAPPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @State private var searchQuery = ""
    @State private var searchIndex = 1
    @State private var selectedCategory: CategoryType = .all
    @State private var selectedCategoryForAnimation: CategoryType = .all
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchSheetTextFieldView(
                    searchQuery: $searchQuery,
                    searchIndex: $searchIndex,
                    selectedCategory: $selectedCategory,
                    selectedCategoryForAnimation: $selectedCategoryForAnimation
                )
                
                SearchSheetCategoryView(
                    startIndex: $searchIndex,
                    selectedCategory: $selectedCategory,
                    categoryAnimation: $selectedCategoryForAnimation
                )
                
                SearchSheetScrollView(
                    selectedCategory: $selectedCategory,
                    searchQuery: $searchQuery,
                    startIndex: $searchIndex
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
