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
    
    @State private var scrollYOffset: CGFloat = 0.0
    @State private var selectedListTab: BookListTab = .bestSeller
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            BookListTopBarView()
            
            BookListTopTabView(
                scrollYOffset: $scrollYOffset,
                selectedListTab: $selectedListTab
            )

            BookListScrollView(
                scrollYOffset: $scrollYOffset,
                selectedListType: $selectedListTab
            )
        }
        .toast(isPresenting: $aladinAPIManager.isPresentingDetailBookErrorToastAlert,
               duration: 2.0, offsetY: -5) {
            aladinAPIManager.showDetailBookErrorToastAlert
        }
    }
}

// MARK: - PREVIEW

#Preview {
    BookListView()
        .environmentObject(AladinAPIManager())
}
