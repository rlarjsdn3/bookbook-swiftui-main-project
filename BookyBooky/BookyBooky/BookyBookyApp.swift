//
//  BookyBookyApp.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/13.
//

import SwiftUI

@main
struct BookyBookyApp: App {
    
    let realmManager = RealmManager.openLocalRealm()
    
    // MARK: - WRAPPER PROPERTIES
    
    @StateObject var aladinAPIManager = AladinAPIManager()
    
    // MARK: - BODY
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    for type in BookListTabItems.allCases {
                        aladinAPIManager.requestBookListAPI(type: type)
                    }
                }
                .environment(\.realm, realmManager)
                .environmentObject(aladinAPIManager)
        }
    }
}
