//
//  SearchView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI

struct SearchView: View {
    @State private var listTypeSelected: ListType = .itemNewAll
    
    var body: some View {
        VStack {
            SearchHeaderView()

            ScrollView(showsIndicators: false) {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        
                    } header: {
                        BookListCategoryView(selected: $listTypeSelected)
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
