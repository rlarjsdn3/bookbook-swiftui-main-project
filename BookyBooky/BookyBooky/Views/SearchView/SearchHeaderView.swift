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
            
            searchLabel
            
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
    var emptyImage: some View {
        Image(systemName: "magnifyingglass")
            .font(.title2)
            .fontWeight(.semibold)
            .hidden()
            .padding(.leading, 15)
    }
    
    var searchLabel: some View {
        Text("검색")
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    var searchImage: some View {
        Image(systemName: "magnifyingglass")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .padding(25)
    }
}

// MARK: - PREVIEW

struct SearchHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHeaderView()
    }
}
