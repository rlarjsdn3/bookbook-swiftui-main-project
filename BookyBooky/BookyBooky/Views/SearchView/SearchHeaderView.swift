//
//  SearchHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchHeaderView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var showSearchSheetView = false
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Spacer()
            
            title
            
            Spacer()
        }
        .fullScreenCover(isPresented: $showSearchSheetView) {
            SearchSheetView()
        }
        .overlay(alignment: .trailing) {
            Button {
                showSearchSheetView = true
            } label: {
                searchImage
            }
        }
        .padding(.vertical)
    }
}

// MARK: - EXTENSIONS

extension SearchHeaderView {
    var title: some View {
        Text("검색")
            .navigationTitleStyle()
    }
    
    var searchImage: some View {
        Image(systemName: "magnifyingglass")
            .navigationBarItemStyle()
    }
}

// MARK: - PREVIEW

struct SearchHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHeaderView()
    }
}
