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
        // 키보드가 나타나더라도 탭 뷰도 함께 올라가지 않도록 합니다.
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
            
            AnalysisView()
                .tag(CustomMainTab.analysis)
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
