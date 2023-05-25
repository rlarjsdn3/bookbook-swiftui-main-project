//
//  SearchDetailDescriptionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchBookIntroView: View {
    
    // MARK: - PROPERTIES
    
    let bookSearchInfo: detailBookInfo.Item
    @Binding var isLoadingCoverImage: Bool
    
    // MARK: - INTIALIZER
    
    init(_ bookSearchInfo: detailBookInfo.Item, isLoadingCoverImage: Binding<Bool>) {
        self.bookSearchInfo = bookSearchInfo
        self._isLoadingCoverImage = isLoadingCoverImage
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookIntroLabel
    }
}

// MARK: - EXTENSIONS

extension SearchBookIntroView {
    var bookIntroLabel: some View {
        VStack {
            HStack {
                aboutBookText
                
                Spacer()
                
                bookLinkButton
            }
            .padding(.top, 5)
            .padding(.horizontal)
            
            bookDescText
        }
        .redacted(reason: isLoadingCoverImage ? .placeholder : [])
        .shimmering(active: isLoadingCoverImage)
    }
    
    var aboutBookText: some View {
        Text("이 책에 관하여")
            .font(.title2)
            .fontWeight(.bold)
            
    }
    
    var bookLinkButton: some View {
        Link(destination: URL(string: bookSearchInfo.link)!) {
            Text("자세히 보기")
        }
        .redacted(reason: isLoadingCoverImage ? .placeholder : [])
    }
    
    var bookDescText: some View {
        ScrollView(showsIndicators: false) {
            Text(bookSearchInfo.description)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal)
    }
}

// MARK: - PREVIEW

struct SearchBookIntroView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookIntroView(
            detailBookInfo.Item.preview,
            isLoadingCoverImage: .constant(false)
        )
    }
}
