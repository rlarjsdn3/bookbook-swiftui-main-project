//
//  HomeTargetBookDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct ReadingBookView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var scrollYOffset = 0.0
    @State private var selectedTab: ReadingBookTabItems = .overview
    @State private var selectedAnimation: ReadingBookTabItems = .overview
    
    // MARK: - BODY
    
    var body: some View {
        //  도서 삭제 시, 책 제목/저자 등 정보가 사라지지 않게 하기 (추후 수정 예정)
        
        VStack(spacing: 0) {
            ReadingBookHeaderView(targetBook: readingBook, scrollYOffset: $scrollYOffset)
            
            ReadingBookScrollView(scrollYOffset: $scrollYOffset, selectedTab: $selectedTab, selectedAnimation: $selectedAnimation, readingBook: readingBook)
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - PREVIEW

struct ReadingBookView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var completeTargetBooks
    
    static var previews: some View {
        ReadingBookView(readingBook: completeTargetBooks[0])
    }
}
