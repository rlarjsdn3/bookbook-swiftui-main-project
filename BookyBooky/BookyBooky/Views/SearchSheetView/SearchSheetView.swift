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
    @EnvironmentObject var alertManager: AlertManager
    
    @StateObject var searchSheetViewData = SearchSheetViewData()
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchSheetTextFieldView()
                
                SearchSheetScrollView()
            }
            .environmentObject(searchSheetViewData)
        }
        .onDisappear {
            searchSheetViewData.bookSearchResult.removeAll()
        }
        .toast(isPresenting: $alertManager.isPresentingSearchLoadingToastAlert)  {
            alertManager.showSearchLoadingToastAlert
        }
        .toast(isPresenting: $alertManager.isPresentingSearchErrorToastAlert,
               duration: 2.0)  {
            alertManager.showSearchErrorToastAlert
        }
        .toast(isPresenting: $alertManager.isPresentingDetailBookErrorToastAlert,
              duration: 2.0) {
           alertManager.showDetailBookErrorToastAlert
        }
        .presentationCornerRadius(30)
    }
}

// MARK: - PREVIEW

#Preview {
    SearchSheetView()
        .environmentObject(AladinAPIManager())
        .environmentObject(AlertManager())
}
