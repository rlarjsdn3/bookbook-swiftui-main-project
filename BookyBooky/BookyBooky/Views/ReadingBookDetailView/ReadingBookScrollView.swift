//
//  ReadingBookDetailScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct ReadingBookScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var startOffset = 0.0
    
    @Namespace var namespace
    
    // MARK: - PROPERTIES
    
    let readingBook: ReadingBook
    @Binding var scrollYOffset: Double
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook, scrollYOffset: Binding<Double>) {
        self.readingBook = readingBook
        self._scrollYOffset = scrollYOffset
    }
    
    // MARK: - BODY
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                ReadingBookInfoView(readingBook)
                
                ReadingBookTabView(
                    readingBook,
                    scrollYOffset: $scrollYOffset,
                    namespace: namespace
                )
            }
            .overlay(alignment: .top) {
                GeometryReader { proxy -> Color in
                    DispatchQueue.main.async {
                        let offset = proxy.frame(in: .global).minY
                        if startOffset == 0 {
                            self.startOffset = offset
                        }
                        withAnimation(.easeInOut(duration: 0.1)) {
                            scrollYOffset = startOffset - offset
                        }

                        print(scrollYOffset)
                    }
                    return Color.clear
                }
                .frame(width: 0, height: 0)
            }
        }
    }
}

struct ReadingBookDetailScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookScrollView(ReadingBook.preview, scrollYOffset: .constant(0.0))
    }
}
