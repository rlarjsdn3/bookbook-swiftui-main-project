//
//  ContentView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/13.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var tabSelected: TabItem = .home
    
    // MARK: - INTIALIZER
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            tabView
            
            RoundedTabView(selected: $tabSelected)
        }
    }
}

// MARK: - EXTENSIONS

extension ContentView {
    var tabView: some View {
        TabView(selection: $tabSelected) {
            HomeView()
                .tag(TabItem.home)
            
            SearchView()
                .tag(TabItem.search)
            
            BookShelfView()
                .tag(TabItem.bookShelf)
            
            Text("Analysis View")
                .tag(TabItem.analysis)
        }
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AladinAPIManager())
    }
}
