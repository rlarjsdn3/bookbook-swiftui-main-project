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
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            ReadingBookHeaderView(readingBook, scrollYOffset: $scrollYOffset)
            
            ReadingBookScrollView(readingBook, scrollYOffset: $scrollYOffset)
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
