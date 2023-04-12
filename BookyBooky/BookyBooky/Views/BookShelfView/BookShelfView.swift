//
//  BookShelfView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/07.
//

import SwiftUI
import RealmSwift

struct BookShelfView: View {
    
    //  MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var scrollYOffset: CGFloat = 0.0
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            BookShelfHeaderView(scrollYOffset: $scrollYOffset)
            
            BookShelfScrollView(scrollYOffset: $scrollYOffset)
        }
    }
}

// MARK: - PREVIEW

struct BookShelfView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfView()
    }
}
