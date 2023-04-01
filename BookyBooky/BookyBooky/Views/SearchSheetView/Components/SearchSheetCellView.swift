//
//  SearchSheetCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/01.
//

import SwiftUI
import SwiftDate

struct SearchSheetCellView: View {
    @State private var isLoading = false
    
    let bookItem: BookList.Item
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                HStack {
                    AsyncImage(url: URL(string: bookItem.cover)) { phase in
                        switch phase {
                        case .empty:
                            CoverShape()
                                .fill(.white)
                                .frame(width: size.width * 0.33, height: 200)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width * 0.33, height: 200)
                        case .failure(_):
                            CoverShape()
                                .fill(.white)
                                .frame(width: size.width * 0.33, height: 200)
                        @unknown default:
                            CoverShape()
                                .fill(.white)
                                .frame(width: size.width * 0.33, height: 200)
                        }
                    }
                    .clipShape(CoverShape())
                    .shadow(color: .black.opacity(0.1), radius: 8, x: -5, y: 5)
                    
                    Spacer()
                }

                HStack {
                    Spacer()
                    
                    ZStack {
                        TextShape()
                            .fill(.white)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: -5, y: 5)
                        
                        VStack(alignment: .leading) {
                            Text(bookItem.originalTitle)
                                .font(.title3)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .padding(.bottom, 2)
                            
                            Text(bookItem.authorInfo)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            
                            HStack(spacing: -3) {
                                Text(bookItem.publisher)
                                
                                Text("・")
                                
                                Text(bookItem.category.rawValue)
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text(bookItem.pubDate)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                    .frame(width: size.width * 0.7, height: 145)
                    .background(.white)
                }
            }
        }
        .frame(height: 200, alignment: .center)
        .padding(.vertical, 5)
    }
}

extension SearchSheetCellView {
    
}

struct SearchSheetCellView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetCellView(bookItem: BookList.Item.preview[0])
    }
}
