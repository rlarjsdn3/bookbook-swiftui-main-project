//
//  SearchDetailSubInfoView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchInfoBoxView: View {
    
    // MARK: - PROPERTIES
    
    var bookInfo: BookInfo.Item
    @Binding var isLoading: Bool
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var showSalesPointDescriptionSheet = false
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            
            salesPoint
            
            Spacer(minLength: 0)
            
            page
            
            Spacer(minLength: 0)
            
            category
        
            Spacer(minLength: 0)
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(15)
        .padding(.horizontal)
        .frame(height: 100)
    }
}

// MARK: - EXTENSIONS

extension SearchInfoBoxView {
    var salesPoint: some View {
        VStack(spacing: 8) {
            HStack(spacing: 3) {
                Text("판매 포인트")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Button {
                    showSalesPointDescriptionSheet = true
                } label: {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.primary)
                }
                // 판매 포인트 설명을 위한 시트(Sheet)
                .sheet(isPresented: $showSalesPointDescriptionSheet) {
                    SalesPointDescSheetView(bookInfo: bookInfo)
                }
            }
            
            Text("\(bookInfo.salesPoint)")
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
        }
        .frame(maxWidth: .infinity)
    }
    
    var page: some View {
        VStack(spacing: 8) {
            Text("페이지")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("\(bookInfo.subInfo.itemPage)")
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
        }
        .frame(maxWidth: .infinity)
    }
    
    var category: some View {
        VStack(spacing: 8) {
            Text("카테고리")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(bookInfo.categoryName.refinedCategory.rawValue)
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - RPEVIEW

struct SearchInfoBoxView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfoBoxView(bookInfo: BookInfo.Item.preview[0], isLoading: .constant(false))
    }
}
