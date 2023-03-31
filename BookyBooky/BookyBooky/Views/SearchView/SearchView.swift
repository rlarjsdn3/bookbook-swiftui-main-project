//
//  SearchView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var listTypeSelected = ListType.bestSeller
    
    var body: some View {
        VStack(spacing: 0) {
            SearchHeaderView()
            
            SearchListTypeView(listTypeSelected: $listTypeSelected)

            ZStack {
                Color("Background")
                
                SearchLazyGridView(listTypeSelected: $listTypeSelected)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(BookViewModel())
    }
}
