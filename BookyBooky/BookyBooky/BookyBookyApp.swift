//
//  BookyBookyApp.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/13.
//

import SwiftUI

@main
struct BookyBookyApp: App {
    @StateObject var bookViewModel = BookViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookViewModel)
        }
    }
}
