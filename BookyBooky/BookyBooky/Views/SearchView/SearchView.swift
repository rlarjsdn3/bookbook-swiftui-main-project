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
        VStack(spacing: 0) {
            SearchHeaderView()
            
            BookListCategoryView(selected: $listTypeSelected)

            ZStack {
                Color("Background")
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(1...100, id: \.self) { index in
                            Text("\(index)")
                        }
                    }
                }
            }
            
            Spacer()
        }
        .onAppear {
            ViewModel().requestBookListAPI(type: .itemNewAll)
        }
        .onChange(of: listTypeSelected) { selected in
            ViewModel().requestBookListAPI(type: selected)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
