//
//  SearchDetailSubInfoView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchBookGrayBoxView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isPresentingSalesPointDescriptionSheet = false
    
    // MARK: - PROPERTIES
    
    var searchBookInfo: detailBookInfo.Item
    @Binding var isLoadingCoverImage: Bool
    
    // MARK: - INTIALIZER
    
    init(_ searchBookInfo: detailBookInfo.Item, isLoadingCoverImage: Binding<Bool>) {
        self.searchBookInfo = searchBookInfo
        self._isLoadingCoverImage = isLoadingCoverImage
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookGrayBox
            .sheet(isPresented: $isPresentingSalesPointDescriptionSheet) {
                SalesPointIntroSheetView(theme: searchBookInfo.category.accentColor)
            }
    }
}

// MARK: - EXTENSIONS

extension SearchBookGrayBoxView {
    var bookGrayBox: some View {
        HStack {
            Spacer(minLength: 0)
            
            salesPointLabel
            
            Spacer(minLength: 0)
            
            pageLabel
            
            Spacer(minLength: 0)
            
            categoryLabel
        
            Spacer(minLength: 0)
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(15)
        .padding(.horizontal)
        .frame(height: 100)
    }
    
    var salesPointLabel: some View {
        VStack(spacing: 8) {
            HStack(spacing: 3) {
                Text("판매 포인트")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Button {
                    isPresentingSalesPointDescriptionSheet = true
                } label: {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.primary)
                }
            }
            
            Text("\(searchBookInfo.salesPoint)")
                .redacted(reason: isLoadingCoverImage ? .placeholder : [])
                .shimmering(active: isLoadingCoverImage)
        }
        .frame(maxWidth: .infinity)
    }
    
    var pageLabel: some View {
        VStack(spacing: 8) {
            Text("페이지")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("\(searchBookInfo.subInfo.itemPage)")
                .redacted(reason: isLoadingCoverImage ? .placeholder : [])
                .shimmering(active: isLoadingCoverImage)
        }
        .frame(maxWidth: .infinity)
    }
    
    var categoryLabel: some View {
        VStack(spacing: 8) {
            Text("카테고리")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(searchBookInfo.category.rawValue)
                .redacted(reason: isLoadingCoverImage ? .placeholder : [])
                .shimmering(active: isLoadingCoverImage)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - RPEVIEW

struct SearchInfoBoxView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookGrayBoxView(
            detailBookInfo.Item.preview[0],
            isLoadingCoverImage: .constant(false)
        )
    }
}
