//
//  SearchDetailSubInfoView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI

struct SearchDetailSubInfoView: View {
    
    // MARK: - PROPERTIES
    
    var bookInfo: BookDetail.Item
    @Binding var isLoading: Bool
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var showSalesPointDescriptionSheet = false
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            
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
                }
                
                Text("\(bookInfo.salesPoint)")
                    .redacted(reason: isLoading ? .placeholder : [])
                    .shimmering(active: isLoading)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("페이지")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("\(bookInfo.subInfo.itemPage)")
                    .redacted(reason: isLoading ? .placeholder : [])
                    .shimmering(active: isLoading)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("카테고리")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(bookInfo.category.rawValue)
                    .redacted(reason: isLoading ? .placeholder : [])
                    .shimmering(active: isLoading)
            }
            .frame(maxWidth: .infinity)
        
            
            Spacer(minLength: 0)
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(15)
        .padding(.horizontal)
        .frame(height: 100)
        // 판매 포인트 설명을 위한 시트(Sheet)
        .sheet(isPresented: $showSalesPointDescriptionSheet) {
            SalesPointDescriptionSheetView(bookInfo: bookInfo)
                .presentationDetents([.height(380)])
                .presentationCornerRadius(30)
        }
    }
}

// MARK: - RPEVIEW

struct SearchDetailSubInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDetailSubInfoView(bookInfo: BookDetail.Item.preview[0], isLoading: .constant(false))
    }
}
