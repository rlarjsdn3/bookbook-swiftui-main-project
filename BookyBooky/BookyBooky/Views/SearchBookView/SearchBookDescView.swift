//
//  SearchDetailDescriptionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchBookDescView: View {
    
    // MARK: - PROPERTIES
    
    let bookInfo: detailBookInfo.Item
    @Binding var isLoadingCoverImage: Bool
    
    // MARK: - INTIALIZER
    
    init(_ bookInfo: detailBookInfo.Item, isLoadingCoverImage: Binding<Bool>) {
        self.bookInfo = bookInfo
        self._isLoadingCoverImage = isLoadingCoverImage
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
        .redacted(reason: isLoadingCoverImage ? .placeholder : [])
        .shimmering(active: isLoadingCoverImage)
    }
    
    var aboutBookText: some View {
        Text("이 책에 관하여")
            .font(.title2)
            .fontWeight(.bold)
            
    }
    
    var moreLinkButton: some View {
        Group {
            if let url = URL(string: bookInfo.link) {
                Link(destination: url) {
                    Text("자세히 보기")
                }
            }
        }
        .redacted(reason: isLoadingCoverImage ? .placeholder : [])
    }
    
    var bookDescText: some View {
        ScrollView(showsIndicators: false) {
            Text(bookInfo.bookDescription)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
}

// MARK: - PREVIEW

struct SearchBookIntroView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookDescView(
            detailBookInfo.Item.preview,
            isLoadingCoverImage: .constant(false)
        )
    }
}