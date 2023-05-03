//
//  ReadingBookDetailScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct ReadingBookScrollView: View {
    @State private var startOffset = 0.0
    
    @Binding var scrollYOffset: Double
    @Binding var selectedTab: ReadingBookTabItems
    @Binding var selectedAnimation: ReadingBookTabItems
    
    @Namespace var underlineAnimation
    
    let readingBook: ReadingBook
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ReadingBookCoverView(readingBook: readingBook)
                
                ReadingBookRenewalButtonView(readingBook: readingBook)
                
                ReadingBookTabSectionView(readingBook: readingBook, selectedTab: $selectedTab, selectedAnimation: $selectedAnimation, scrollYOffset: $scrollYOffset, underlineAnimation: underlineAnimation)
                
                Spacer()
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
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        ReadingBookScrollView(scrollYOffset: .constant(0.0), selectedTab: .constant(.overview), selectedAnimation: .constant(.overview), readingBook: readingBooks[0])
    }
}
