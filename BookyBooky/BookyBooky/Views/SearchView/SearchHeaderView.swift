//
//  SearchHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchHeaderView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isPresentingSearchSheetView = false
    
    // MARK: - BODY
    
    var body: some View {
        navigationBar
            .sheet(isPresented: $isPresentingSearchSheetView) {
                SearchSheetView()
            }
    }
}

// MARK: - EXTENSIONS

extension SearchHeaderView {
    var navigationBar: some View {
        HStack {
            Spacer()
            
            navigationBarTitle
            
            Spacer()
        }
        .overlay {
            navigationBarButtons
        }
        .padding(.vertical)
    }
    
    var navigationBarTitle: some View {
        Text("검색")
            .navigationTitleStyle()
    }
    
    var navigationBarButtons: some View {
        HStack {
            Spacer()
            
            Button {
                isPresentingSearchSheetView = true
            } label: {
                searchSFSymbolsImage
            }
        }
    }
    
    var searchSFSymbolsImage: some View {
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
