//
//  ReadingBookDetailScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct CompleteBookScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var completeBookViewData: CompleteBookViewData
    
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var completeBook: CompleteBook
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook) {
        self.completeBook = completeBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        scrollContent
    }
}

// MARK: - EXTENSIONS

extension CompleteBookScrollView {
    var scrollContent: some View {
        TrackableVerticalScrollView(yOffset: $completeBookViewData.scrollYOffset) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                CompleteBookMainInfoView(completeBook)
                
                CompleteBookTabView(completeBook)
            }
        }
    }
}

// MARK: - PREVIEW

#Preview {
    CompleteBookScrollView(CompleteBook.preview)
        .environmentObject(CompleteBookViewData())
}
