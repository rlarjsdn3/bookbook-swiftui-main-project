//
//  SearchHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct BookListTopBarView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @State private var isPresentingSearchSheetView = false
    
    // MARK: - BODY
    
    var body: some View {
        navigationTopBar
            .sheet(isPresented: $isPresentingSearchSheetView) {
                SearchSheetView()
            }
    }
}

// MARK: - EXTENSIONS

extension BookListTopBarView {
    var navigationTopBar: some View {
        HStack {
            Spacer()
            
            navigationTopBarTitle
            
            Spacer()
        }
        .overlay {
            navigationTopBarButtonGroup
        }
        .padding(.vertical)
    }
    
    var navigationTopBarTitle: some View {
        Text("검색")
            .navigationTitleStyle()
    }
    
    var navigationTopBarButtonGroup: some View {
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

#Preview {
    BookListTopBarView()
        .environmentObject(AladinAPIManager())
}
