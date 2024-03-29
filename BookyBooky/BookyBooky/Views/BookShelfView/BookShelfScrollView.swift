//
//  BookShelfScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI
import RealmSwift

struct BookShelfScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    @EnvironmentObject var bookShelfViewData: BookShelfViewData
    
    @ObservedResults(CompleteBook.self) var compBooks
    @ObservedResults(FavoriteBook.self) var favBooks
    
    // MARK: - BODY
    
    var body: some View {
        scrollContent
    }
}

// MARK: - EXTENSIONS

extension BookShelfScrollView {
    var scrollContent: some View {
        ScrollView {
            // TrackableVerticalScrollView(yOffset: $bookShelfViewData.scrollYOffset) {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    BookShelfSummarySectionView()
                    
                    BookShelfFBookSectionView()
                    
                    BookShelfCBookSectionView()
                }
            }
//        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - PREVIEW

struct BookShelfScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfScrollView()
            .environmentObject(RealmManager())
            .environmentObject(BookShelfViewData())
    }
}
