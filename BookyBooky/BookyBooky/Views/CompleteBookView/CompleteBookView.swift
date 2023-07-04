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
    
    @StateObject var completeBookViewData = CompleteBookViewData()
    
    // MARK: - PROPERTIES
    
    let completeBook: CompleteBook
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook) {
        self.completeBook = completeBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CompleteBookTopBarView(completeBook)
                
                CompleteBookScrollView(completeBook)
            }
            .navigationBarBackButtonHidden()
            .environmentObject(completeBookViewData)
        }
        .toast(
            isPresenting: $realmManager.isPresentingReadingBookEditSuccessToastAlert,
            duration: 1.0) {
            realmManager.showReadingBookEditSuccessToastAlert(completeBook.category.themeColor)
        }
        .toast(
            isPresenting: $realmManager.isPresentingReadingBookRenewalSuccessToastAlert,
            duration: 1.0) {
                realmManager.showReadingBookRenewalSuccessToastAlert(completeBook.category.themeColor)
        }
        .toast(
            isPresenting: $realmManager.isPresentingAddSentenceSuccessToastAlert,
            duration: 1.0) {
            realmManager.showAddSentenceSuccessToastAlert(completeBook.category.themeColor)
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
