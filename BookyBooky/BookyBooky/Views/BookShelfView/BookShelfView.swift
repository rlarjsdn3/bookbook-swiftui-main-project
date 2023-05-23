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
    
    @State private var scrollYOffset: Double = 0.0
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                BookShelfHeaderView()
                
                BookShelfScrollView($scrollYOffset)
            }
        }
    }
}

// MARK: - PREVIEW

struct BookShelfView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfView()
    }
}
