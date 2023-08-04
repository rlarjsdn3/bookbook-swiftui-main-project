//
//  BookShelfView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/07.
//

import SwiftUI
import RealmSwift

struct BookShelfView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @StateObject var bookShelfViewData = BookShelfViewData()
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                BookShelfTopBarView()
                
                BookShelfScrollView()
            }
            .environmentObject(bookShelfViewData)
        }
    }
}

// MARK: - PREVIEW

#Preview {
    BookShelfView()
}
