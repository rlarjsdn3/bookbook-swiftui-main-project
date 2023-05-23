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
        navigationBar
    }
}

// MARK: - EXTENSIONS

extension BookShelfHeaderView {
    var navigationBar: some View {
        HStack {
            Spacer()
            
            navigationBarTitle
            
            Spacer()
        }
        .overlay(alignment: .trailing) {
            navigationBarButtons
        }
        .padding(.vertical)
    }
    
    var navigationBarTitle: some View {
        Text("책장")
            .navigationTitleStyle()
    }
    
    var navigationBarButtons: some View {
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
