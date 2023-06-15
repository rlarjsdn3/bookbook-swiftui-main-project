//
//  SearchView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI

struct SearchListView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @State private var scrollYOffset: CGFloat = 0.0
    @State private var listTypeSelected = BookListTabType.bestSeller
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            SearchHeaderView()
            
            SearchTabView($scrollYOffset, selectedListType: $listTypeSelected)

            SearchScrollView($scrollYOffset, selectedListType: $listTypeSelected)
        }
        .toast(isPresenting: $aladinAPIManager.isPresentingDetailBookErrorToastAlert,
               duration: 2.0, offsetY: -5) {
            aladinAPIManager.showDetailBookErrorToastAlert
        }
    }
}

// MARK: - PREVIEW

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListView()
            .environmentObject(AladinAPIManager())
    }
}
