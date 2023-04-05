//
//  BookyBookyApp.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/13.
//

import SwiftUI

@main
struct BookyBookyApp: App {
    
    // MARK: - CONSTATNT PROPERTIES
    
    let realmManager = RealmManager.shared
    
    // MARK: - WRAPPER PROPERTIES
    
    @StateObject var aladinAPIManager = AladinAPIManager()
    
    // MARK: - BODY
    
    var body: some Scene {
        WindowGroup {
            if let realm = realmManager.realm {
                ContentView()
                    .onAppear {
                        for type in ListType.allCases {
                            aladinAPIManager.requestBookListAPI(type: type)
                        }
                    }
                    .environmentObject(aladinAPIManager)
                    .environment(\.realm, realm)
            } else {
                // 스플래쉬 뷰ㅋ
            }
        }
    }
}
