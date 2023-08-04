//
//  SearchDetailSubInfoView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import Shimmer

struct SearchBookSubInfoView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var searchBookViewData: SearchBookViewData
    
    @State private var isPresentingSalesPointDescriptionSheet = false
    
    // MARK: - PROPERTIES
    
    let book: DetailBookInfo.Item
    
    // MARK: - INTIALIZER
    
    init(_ book: DetailBookInfo.Item) {
        self.book = book
    }
    
    // MARK: - BODY
    
    var body: some View {
        subInfoArea
            .sheet(isPresented: $isPresentingSalesPointDescriptionSheet) {
                SalesPointDescSheetView(theme: book.bookCategory.themeColor)
                    .presentationCornerRadius(30)
                    // 베젤이 없는 아이폰(iPhone 14 등)은 시트 높이를 420으로 설정
                    // 베젤이 있는 아이폰(iPhone SE 등)은 시트 높이를 450으로 설정
                    .presentationDetents([.height(safeAreaInsets.bottom == 0 ? 450 : 420)])
            }
    }
}

// MARK: - EXTENSIONS

extension SearchBookSubInfoView {
    var subInfoArea: some View {
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
            
            Text("\(book.salesPoint)")
                .redacted(reason: searchBookViewData.isLoadingCoverImage ? .placeholder : [])
                .shimmering(active: searchBookViewData.isLoadingCoverImage)
        }
        .frame(maxWidth: .infinity)
    }
    
    var pageLabel: some View {
        VStack(spacing: 8) {
            Text("페이지")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("\(book.subInfo.itemPage)")
                .redacted(reason: searchBookViewData.isLoadingCoverImage ? .placeholder : [])
                .shimmering(active: searchBookViewData.isLoadingCoverImage)
        }
        .frame(maxWidth: .infinity)
    }
    
    var categoryLabel: some View {
        VStack(spacing: 8) {
            Text("카테고리")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(book.bookCategory.name)
                .redacted(reason: searchBookViewData.isLoadingCoverImage ? .placeholder : [])
                .shimmering(active: searchBookViewData.isLoadingCoverImage)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - RPEVIEW

#Preview {
    SearchBookSubInfoView(DetailBookInfo.Item.preview)
        .environmentObject(SearchBookViewData())
}
