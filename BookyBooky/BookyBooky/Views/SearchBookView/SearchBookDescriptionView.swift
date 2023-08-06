//
//  SearchDetailDescriptionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import Shimmer

struct SearchBookDescriptionView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var searchBookViewData: SearchBookViewData
    
    // MARK: - PROPERTIES
    
    let book: DetailBookInfo.Item
    
    // MARK: - INTIALIZER
    
    init(_ book: DetailBookInfo.Item) {
        self.book = book
    }
    
    // MARK: - BODY
    
    var body: some View {
        descriptionLabel
    }
}

// MARK: - EXTENSIONS

extension SearchBookDescriptionView {
    var descriptionLabel: some View {
        VStack {
            HStack {
                aboutBookText
                
                Spacer()
                
                moreLinkButton
            }
            .padding(.top, 5)
            .padding(.horizontal)
            
            descriptionText
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
            if let url = URL(string: book.link) {
                Link(destination: url) {
                    Text("자세히 보기")
                }
            }
        }
        .redacted(reason: searchBookViewData.isLoadingCoverImage ? .placeholder : [])
    }
    
    var descriptionText: some View {
        ScrollView(showsIndicators: false) {
            Text(book.bookDescription)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
}

// MARK: - PREVIEW

struct SearchBookDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookDescriptionView(DetailBookInfo.Item.preview)
            .environmentObject(SearchBookViewData())
    }
}
