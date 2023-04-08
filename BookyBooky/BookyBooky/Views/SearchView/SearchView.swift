//
//  SearchView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @State private var listTypeSelected = BookListTabItem.bestSeller
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            SearchHeaderView()
            
            SearchListTypeView(listTypeSelected: $listTypeSelected)

            SearchLazyGridView(listTypeSelected: $listTypeSelected)
        }
    }
}

// MARK: - PREVIEW

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(AladinAPIManager())
    }
}
