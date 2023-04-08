//
//  BookShelfView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/07.
//

import SwiftUI
import RealmSwift

struct BookShelfView: View {
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var startOffset: CGFloat = 0.0
    @State private var scrollYOffset: CGFloat = 0.0
    
    var body: some View {
        VStack(spacing: 0) {
            BookShelfHeaderView(scrollYOffset: $scrollYOffset)
            
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Text("책장")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    Section {
                        
                    } header: {
                        HStack {
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
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
            
            Spacer()
        }
    }
}

struct BookShelfView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfView()
    }
}
