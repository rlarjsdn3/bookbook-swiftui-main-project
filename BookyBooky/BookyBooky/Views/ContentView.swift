//
//  ContentView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/13.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelected: TabItem = .home
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack {
            TabView(selection: $tabSelected) {
                HomeView()
                    .tag(TabItem.home)
                
                Text("Search View")
                    .tag(TabItem.search)
                
                Text("BookShelf View")
                    .tag(TabItem.bookShelf)
                
                Text("Analysis View")
                    .tag(TabItem.analysis)
            }
            
            RoundedTabView(selected: $tabSelected)
        }
        .onAppear {
            ViewModel().requestBookListAPI(type: .bestSeller)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
