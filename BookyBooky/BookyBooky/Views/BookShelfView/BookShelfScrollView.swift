//
//  BookShelfScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI
import RealmSwift

struct BookShelfScrollView: View {
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var tapISBN13 = ""
    @State private var showFavoriteBookInfo = false
    @State private var startOffset: CGFloat = 0.0
    @Binding var scrollYOffset: CGFloat
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Text("책장")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Section {
                    scrollFavoriteBooks
                } header: {
                    HStack {
                        Text("찜한 도서")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("자세히 보기")
                        }

                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .opacity(scrollYOffset > 70.0 ? 1 : 0)
                    }
                }
            }
            .overlay(alignment: .top) {
                GeometryReader { proxy -> Color in
                    DispatchQueue.main.async {
                        let offset = proxy.frame(in: .global).minY
                        if startOffset == 0 {
                            self.startOffset = offset
                        }
                        withAnimation(.easeInOut(duration: 0.2)) {
                            scrollYOffset = startOffset - offset
                        }
                        print(scrollYOffset)
                    }
                    return Color.clear
                }
                .frame(width: 0, height: 0)
            }
        }
        .sheet(isPresented: $showFavoriteBookInfo) {
            if !tapISBN13.isEmpty {
                SearchSheetView(viewType: .favorite(isbn13: tapISBN13))
            }
        }
    }
}

extension BookShelfScrollView {
    var scrollFavoriteBooks: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(favoriteBooks) { favoriteBook in
                    FavoriteBookCellView(favoriteBook: favoriteBook)
                  
                }
            }
        }
        .padding(.horizontal, 3)
    }
}

struct BookShelfScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfScrollView(scrollYOffset: .constant(0.0))
    }
}
