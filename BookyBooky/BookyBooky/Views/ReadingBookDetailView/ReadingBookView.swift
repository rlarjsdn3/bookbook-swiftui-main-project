//
//  HomeTargetBookDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift
import AlertToast

struct ReadingBookView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var scrollYOffset = 0.0
    @State private var selectedTab: ReadingBookTabItems = .overview
    @State private var selectedAnimation: ReadingBookTabItems = .overview
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            ReadingBookHeaderView(readingBook: readingBook, scrollYOffset: $scrollYOffset)
            
            ReadingBookScrollView(scrollYOffset: $scrollYOffset, selectedTab: $selectedTab, selectedAnimation: $selectedAnimation, readingBook: readingBook)
        }
        .toast(isPresenting: $realmManager.isPresentingTargetBookEditComleteToastAlert, duration: 1.0) {
            realmManager.showTargetBookEditCompleteToastAlert(readingBook.category.accentColor)
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - PREVIEW

struct ReadingBookView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var completeTargetBooks
    
    static var previews: some View {
        ReadingBookView(readingBook: completeTargetBooks[0])
            .environmentObject(RealmManager())
    }
}
