//
//  SearchSheetCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/01.
//

import SwiftUI
import SwiftDate

struct SearchSheetCellView: View {
    @State private var isLoading = true
    
    let bookItem: BookList.Item
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                HStack {
                    AsyncImage(url: URL(string: bookItem.cover)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width * 0.32, height: 180)
                            .onAppear {
                                isLoading = false
                            }
                    } placeholder: {
                        CoverShape()
                            .fill(.gray.opacity(0.25))
                            .frame(width: size.width * 0.32, height: 180)
                            .shimmering(active: isLoading)
                    }
                    .clipShape(CoverShape())
                    .shadow(color: .black.opacity(0.1), radius: 8, x: -5, y: 5)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 5, y: -5)
                    
                    Spacer()
                }

                HStack {
                    Spacer()
                    
                    ZStack {
                        TextShape()
                            .fill(.orange)
                            .offset(y: 4)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: -5, y: 5)
                        
                        TextShape()
                            .fill(.white)
                            .offset(y: -4)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 5, y: 5)
                        
                        
                        VStack( alignment: .leading, spacing: 2) {
                            Text(bookItem.originalTitle)
                                .font(.title3)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .padding(.bottom, 2)
                            
                            Text(bookItem.authorInfo)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            
                            HStack(spacing: 2) {
                                Text(bookItem.publisher)
                                
                                Text("・")
                                
                                Text(bookItem.category.rawValue)
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(bookItem.publishDate, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .redacted(reason: isLoading ? .placeholder : [])
                        .shimmering(active: isLoading)
                        .padding()
                    }
                    .frame(width: size.width * 0.71, height: 130)
                }
            }
        }
        .frame(height: 180)
        .padding(.top, 20)
    }
}

extension SearchSheetCellView {
    
}

struct SearchSheetCellView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetCellView(bookItem: BookList.Item.preview[0])
    }
}
