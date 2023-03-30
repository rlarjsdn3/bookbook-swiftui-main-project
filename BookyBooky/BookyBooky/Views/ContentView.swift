//
//  ContentView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/13.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelected: RoundedTabItem = .home
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack {
            TabView(selection: $tabSelected) {
                HomeView()
                    .tag(RoundedTabItem.home)
                
                SearchView()
                    .tag(RoundedTabItem.search)
                
                Text("BookShelf View")
                    .tag(RoundedTabItem.bookShelf)
                
                Text("Analysis View")
                    .tag(RoundedTabItem.analysis)
            }
            
            RoundedTabView(selected: $tabSelected)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
