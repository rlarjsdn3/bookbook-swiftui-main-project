//
//  SearchDetailDescriptionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailDescriptionView: View {
    
    // MARK: - PROPERTIEs
    
    let bookInfo: BookDetail.Item
    @Binding var isLoading: Bool
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            HStack {
                Text("이 책에 관하여")
                    .font(.title2)
                    .fontWeight(.bold)
                    .redacted(reason: isLoading ? .placeholder : [])
                    .shimmering(active: isLoading)
                
                Spacer()
                
                Link(destination: URL(string: bookInfo.link)!) {
                    Text("자세히 보기")
                }
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
                .disabled(isLoading)
            }
            .padding(.top, 5)
            .padding(.horizontal)
            
            ScrollView(showsIndicators: false) {
                Text(bookInfo.description)
                    .multilineTextAlignment(.leading)
                    .redacted(reason: isLoading ? .placeholder : [])
                    .shimmering(active: isLoading)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - PREVIEW

struct SearchDetailDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDetailDescriptionView(bookInfo: BookDetail.Item.preview[0], isLoading: .constant(false))
    }
}
