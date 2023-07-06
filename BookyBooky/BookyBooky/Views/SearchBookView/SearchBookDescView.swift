//
//  SearchDetailDescriptionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchBookDescView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var searchBookViewData: SearchBookViewData
    
    // MARK: - PROPERTIES
    
    let bookItem: detailBookItem.Item
    
    // MARK: - INTIALIZER
    
    init(_ bookItem: detailBookItem.Item) {
        self.bookItem = bookItem
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookDescLabel
    }
}

// MARK: - EXTENSIONS

extension SearchBookDescView {
    var bookDescLabel: some View {
        VStack {
            HStack {
                aboutBookText
                
                Spacer()
                
                moreLinkButton
            }
            .padding(.top, 5)
            .padding(.horizontal)
            
            bookDescText
        }
        .redacted(reason: searchBookViewData.isLoadingCoverImage ? .placeholder : [])
        .shimmering(active: searchBookViewData.isLoadingCoverImage)
    }
    
    var aboutBookText: some View {
        Text("이 책에 관하여")
            .font(.title2)
            .fontWeight(.bold)
            
    }
    
    var moreLinkButton: some View {
        Group {
            if let url = URL(string: bookItem.link) {
                Link(destination: url) {
                    Text("자세히 보기")
                }
            }
        }
        .redacted(reason: searchBookViewData.isLoadingCoverImage ? .placeholder : [])
    }
    
    var bookDescText: some View {
        ScrollView(showsIndicators: false) {
            Text(bookItem.bookDescription)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
}

// MARK: - PREVIEW

struct SearchBookIntroView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookDescView(detailBookItem.Item.preview)
            .environmentObject(SearchBookViewData())
    }
}
