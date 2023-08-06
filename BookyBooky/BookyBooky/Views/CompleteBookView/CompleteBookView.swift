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
    @EnvironmentObject var alertManager: AlertManager
    
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
            isPresenting: $alertManager.isPresentingReadingBookEditSuccessToastAlert,
            duration: 1.0) {
            alertManager.showReadingBookEditSuccessToastAlert(completeBook.category.themeColor)
        }
        .toast(
            isPresenting: $alertManager.isPresentingReadingBookRenewalSuccessToastAlert,
            duration: 1.0) {
                alertManager.showReadingBookRenewalSuccessToastAlert(completeBook.category.themeColor)
        }
        .toast(
            isPresenting: $alertManager.isPresentingAddSentenceSuccessToastAlert,
            duration: 1.0) {
            alertManager.showAddSentenceSuccessToastAlert(completeBook.category.themeColor)
        }
    }
}

// MARK: - PREVIEW

struct CompleteBookView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteBookView(CompleteBook.preview)
            .environmentObject(RealmManager())
            .environmentObject(AlertManager())
    }
}
