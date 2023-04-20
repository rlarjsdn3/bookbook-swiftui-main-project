//
//  BookShelfHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI

struct BookShelfHeaderView: View {
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Spacer()
            
            bookShelfTitle
            
            Spacer()
        }
        .overlay(alignment: .trailing) {
            bookmarkButton
        }
        .padding(.vertical)
    }
}

// MARK: - EXTENSIONS

extension BookShelfHeaderView {
    var bookShelfTitle: some View {
        Text("책장")
            .navigationTitleStyle()
    }
    
    var bookmarkButton: some View {
        Button {
            // do something...
        } label: {
            Image(systemName: "bookmark.fill")
                .navigationBarItemStyle()
        }
    }
}

// MARK: - PREVIEW

struct BookShelfHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfHeaderView()
    }
}
