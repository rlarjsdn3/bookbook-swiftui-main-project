//
//  BookShelfHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI

struct BookShelfTopBarView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isPresentingCollectSenetenceView = false
    
    // MARK: - BODY
    
    var body: some View {
        navigationTopBar
            .fullScreenCover(isPresented: $isPresentingCollectSenetenceView) {
                BookShelfSentenceListView()
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
            topBarButtonGroup
        }
        .padding(.vertical)
    }
    
    var navigationTopBarTitle: some View {
        Text("책장")
            .navigationTitleStyle()
    }
    
    var topBarButtonGroup: some View {
        Button {
            isPresentingCollectSenetenceView = true
        } label: {
            Image(systemName: "bookmark.fill")
                .navigationBarItemStyle()
        }
    }
}

// MARK: - PREVIEW

struct BookShelfTopBarView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfTopBarView()
    }
}
