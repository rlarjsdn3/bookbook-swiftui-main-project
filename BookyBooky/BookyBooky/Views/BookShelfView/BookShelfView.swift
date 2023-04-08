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
            VStack {
                BookShelfHeaderView()
                
                ZStack {
                    Color("Background")
                }
                
                Spacer()
            }
        
    }
}

struct BookShelfView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfView()
    }
}
