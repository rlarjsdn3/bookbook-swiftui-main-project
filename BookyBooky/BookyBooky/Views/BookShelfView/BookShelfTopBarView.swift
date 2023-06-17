//
//  BookShelfHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI

struct BookShelfTopBarView: View {
    
    // MARKL - WRAPPER PROPERTIES
    
    @State private var isPresentingCollectSenetenceView = false
    
    // MARK: - BODY
    
    var body: some View {
        navigationTopBar
            .fullScreenCover(isPresented: $isPresentingCollectSenetenceView) {
                BookShelfSentenceView()
            }
    }
}

// MARK: - EXTENSIONS

extension BookShelfTopBarView {
    var navigationTopBar: some View {
        HStack {
            Spacer()
            
            navigationTopBarTitle
            
            Spacer()
        }
        .overlay(alignment: .trailing) {
            navigationTopBarButtonGroup
        }
        .padding(.vertical)
    }
    
    var navigationTopBarTitle: some View {
        Text("책장")
            .navigationTitleStyle()
    }
    
    var navigationTopBarButtonGroup: some View {
        Button {
            isPresentingCollectSenetenceView = true
        } label: {
            Image(systemName: "bookmark.fill")
                .navigationBarItemStyle()
        }
    }
}

// MARK: - PREVIEW

struct BookShelfHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfTopBarView()
    }
}
