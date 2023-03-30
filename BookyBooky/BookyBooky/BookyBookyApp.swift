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
                .onAppear {
                    bookViewModel.requestBookListAPI(type: .bestSeller)
                    bookViewModel.requestBookListAPI(type: .itemNewAll)
                    bookViewModel.requestBookListAPI(type: .itemNewSpecial)
                    bookViewModel.requestBookListAPI(type: .blogBest)
                }
                .environmentObject(bookViewModel)
        }
    }
}
