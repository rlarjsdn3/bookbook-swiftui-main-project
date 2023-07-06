//
//  SearchView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI

struct BookListView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @StateObject var bookListViewData = BookListViewData()
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            BookListTopBarView()
            
            BookListTopTabView()

            BookListScrollView()
        }
        .toast(isPresenting: $aladinAPIManager.isPresentingDetailBookErrorToastAlert,
               duration: 2.0, offsetY: -5) {
            aladinAPIManager.showDetailBookErrorToastAlert
        }
       .environmentObject(bookListViewData)
    }
}

// MARK: - PREVIEW

#Preview {
    BookListView()
        .environmentObject(AladinAPIManager())
}
