//
//  BookyBookyApp.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/13.
//

import SwiftUI

@main
struct BookyBookyApp: App {
    
    // MARK: - WRAPPER PROPERTIES
    
    @StateObject var realmManager = RealmManager()
    @StateObject var aladinAPIManager = AladinAPIManager()
    
    // MARK: - BODY
    
    var body: some Scene {
        WindowGroup {
            if let _ = realmManager.realm {
                ContentView()
                    .onAppear {
                        for type in BookListTabType.allCases {
                            aladinAPIManager.requestBookListAPI(of: type)
                        }
                    }
                    .environmentObject(realmManager)
                    .environmentObject(aladinAPIManager)
            } else {
                Text("Error")
            }
        }
    }
}
