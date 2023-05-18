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
            ReadingBookHeaderView(
                readingBook,
                scrollYOffset: $scrollYOffset
            )
            
            ReadingBookMainView(
                scrollYOffset: $scrollYOffset,
                selectedTab: $selectedTab,
                selectedAnimation: $selectedAnimation,
                readingBook: readingBook
            )
        }
        .toast(
            isPresenting: $realmManager.isPresentingReadingBookEditComleteToastAlert,
            duration: 1.0) {
            realmManager.showTargetBookEditCompleteToastAlert(readingBook.category.accentColor)
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - PREVIEW

struct ReadingBookView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookView(readingBook: ReadingBook.preview)
            .environmentObject(RealmManager())
    }
}
