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
    
    @StateObject var bookViewModel = BookViewModel()
    
    // MARK: - BODY
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    for type in ListType.allCases {
                        bookViewModel.requestBookListAPI(type: type)
                    }
                }
                .environmentObject(bookViewModel)
        }
    }
}
