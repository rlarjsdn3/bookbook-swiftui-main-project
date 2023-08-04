//
//  SearchView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI
import AlertToast

struct BookListView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    @EnvironmentObject var alertManager: AlertManager
    
    @StateObject var bookListViewData = BookListViewData()
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            BookListTopBarView()
            
            BookListTabView()

            BookListScrollView()
        }
        .toast(isPresenting: $alertManager.isPresentingBookListLoadingToastAlert) {
            alertManager.showBookListLoadingToastAlert
        }
        .toast(isPresenting: $alertManager.isPresentingDetailBookErrorToastAlert,
               duration: 2.0, offsetY: -5) {
            alertManager.showDetailBookErrorToastAlert
        }
        .onAppear {
           requestBookListInfo()
        }
       .environmentObject(bookListViewData)
    }
    
    func requestBookListInfo() {
        for type in BookListTab.allCases {
            aladinAPIManager.requestBookList(of: type) { book in
                DispatchQueue.main.async {
                    if let book = book {
                        switch type {
                        case .bestSeller:
                            bookListViewData.bestSeller = book.item
                        case .itemNewAll:
                            bookListViewData.itemNewAll = book.item
                        case .itemNewSpecial:
                            bookListViewData.itemNewSpecial = book.item
                        case .blogBest:
                            bookListViewData.blogBest = book.item
                        }
                    }
                }
            }
        }
    }
}

// MARK: - PREVIEW

#Preview {
    BookListView()
        .environmentObject(AladinAPIManager())
        .environmentObject(AlertManager())
}
