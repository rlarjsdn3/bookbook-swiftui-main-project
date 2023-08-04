//
//  ContentView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/13.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var selectedMainTab: CustomMainTab = .home
    
    // MARK: - INTIALIZER
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            defaultTabView
            
            CustomMainTabView(selected: $selectedMainTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - EXTENSIONS

extension ContentView {
    var defaultTabView: some View {
        TabView(selection: $selectedMainTab) {
            HomeView()
                .tag(CustomMainTab.home)
            
            BookListView()
                .tag(CustomMainTab.search)
            
            BookShelfView()
                .tag(CustomMainTab.bookShelf)
            
            // for iOS 17.0
            #if false
                AnalysisView()
                    .tag(CustomMainTab.analysis)
            #endif
        }
    }
}

// MARK: - PREVIEW

#Preview {
    ContentView()
}
