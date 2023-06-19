//
//  HomeTargetBookDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift
import AlertToast

struct CompleteBookView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var scrollYOffset: CGFloat = 0.0
    
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var readingBook: CompleteBook
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: CompleteBook) {
        self.readingBook = readingBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CompleteBookTopBarView(readingBook, scrollYOffset: $scrollYOffset)
                
                CompleteBookScrollView(readingBook, scrollYOffset: $scrollYOffset)
            }
            .navigationBarBackButtonHidden()
        }
        .toast(
            isPresenting: $realmManager.isPresentingReadingBookEditSuccessToastAlert,
            duration: 1.0) {
            realmManager.showReadingBookEditSuccessToastAlert(readingBook.category.themeColor)
        }
        .toast(
            isPresenting: $realmManager.isPresentingReadingBookRenewalSuccessToastAlert,
            duration: 1.0) {
            realmManager.showReadingBookRenewalSuccessToastAlert(readingBook.category.themeColor)
        }
        .toast(
            isPresenting: $realmManager.isPresentingAddSentenceSuccessToastAlert,
            duration: 1.0) {
            realmManager.showAddSentenceSuccessToastAlert(readingBook.category.themeColor)
        }
    }
}

// MARK: - PREVIEW

struct ReadingBookView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteBookView(CompleteBook.preview)
            .environmentObject(RealmManager())
    }
}
