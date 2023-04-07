//
//  BookShelfView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/07.
//

import SwiftUI
import RealmSwift

struct BookShelfView: View {
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    var body: some View {
        List {
            ForEach(favoriteBooks) { favoriteBook in
                Text(favoriteBook.title)
            }
        }
    }
}

struct BookShelfView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfView()
    }
}
