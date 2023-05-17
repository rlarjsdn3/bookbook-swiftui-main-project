//
//  ContentView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/13.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var tabSelected: RoundedTabTypes = .home
    
    // MARK: - INTIALIZER
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            defaultTabView
            
            RoundedTabView(selectedTabBarItem: $tabSelected)
        }
        // 키보드가 나타나더라도 탭 뷰도 함께 올라가지 않도록 합니다.
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - EXTENSIONS

extension ContentView {
    var defaultTabView: some View {
        TabView(selection: $tabSelected) {
            HomeView()
                .tag(RoundedTabTypes.home)
            
            SearchView()
                .tag(RoundedTabTypes.search)
            
            BookShelfView()
                .tag(RoundedTabTypes.bookShelf)
            
            AnalysisView()
                .tag(RoundedTabTypes.analysis)
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
