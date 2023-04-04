//
//  SearchDetailDescriptionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchInfoDescView: View {
    
    // MARK: - PROPERTIEs
    
    let bookInfo: BookInfo.Item
    @Binding var isLoading: Bool
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            HStack {
                aboutBook
                
                Spacer()
                
                bookLink
            }
            .padding(.top, 5)
            .padding(.horizontal)
            
            bookDesc
        }
    }
}

// MARK: - EXTENSIONS

extension SearchInfoDescView {
    var aboutBook: some View {
        Text("이 책에 관하여")
            .font(.title2)
            .fontWeight(.bold)
            .redacted(reason: isLoading ? .placeholder : [])
            .shimmering(active: isLoading)
    }
    
    var bookLink: some View {
        Link(destination: URL(string: bookInfo.link)!) {
            Text("자세히 보기")
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .shimmering(active: isLoading)
        .disabled(isLoading)
    }
    
    var bookDesc: some View {
        ScrollView(showsIndicators: false) {
            Text(bookInfo.description)
                .multilineTextAlignment(.leading)
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
        }
        .padding(.horizontal)
    }
}

// MARK: - PREVIEW

struct SearchInfoDescView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfoDescView(bookInfo: BookInfo.Item.preview[0], isLoading: .constant(false))
    }
}
