//
//  ContentView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/13.
//

import SwiftUI
import Network
import AlertToast

struct ContentView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var alertManager: AlertManager
    
    @State private var selectedTab: CustomMainTab = .home
    
    // MARK: - COMPUTED PROPERTIES
    
    var alertToastOffsetY: Double {
        safeAreaInsets.bottom == 0 ? -25.0 : 5.0
    }
    
    // MARK: - INTIALIZER
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            defaultTabView
            
            CustomTabView(selection: $selectedTab)
        }
        .onAppear {
            let monitor = NWPathMonitor()
            
            monitor.pathUpdateHandler = { path in
                DispatchQueue.main.async {
                    alertManager.isPresentingNetworkErrorToastAlert = (path.status == .unsatisfied)
                }
            }

            let queue = DispatchQueue.global()
            monitor.start(queue: queue)
        }
        .toast(isPresenting: $alertManager.isPresentingNetworkErrorToastAlert, duration: .infinity, tapToDismiss: true, offsetY: alertToastOffsetY) {
            alertManager.showNetworkErrorToastAlert
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - EXTENSIONS

extension ContentView {
    var defaultTabView: some View {
        TabView(selection: $selectedTab) {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AlertManager())
    }
}
