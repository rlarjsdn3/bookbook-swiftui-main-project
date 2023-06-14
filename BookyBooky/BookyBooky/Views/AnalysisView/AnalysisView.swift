//
//  AnalysisView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/20.
//

import SwiftUI
import RealmSwift
import Charts

struct TotalPagesReadByCategory: Identifiable, Hashable {
    var category: CategoryType
    var pages: Int
    
    var id: CategoryType { category }
}

struct DailyPagesRead: Identifiable, Hashable {
    var date: Date
    var pages: Int
    
    var id: Date { date }
}

struct MonthlyCompleteBook: Identifiable, Hashable {
    var date: Date
    var count: Int
    
    var id: Date { date }
}


struct AnalysisView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(ReadingBook.self) var readingBooks

    @State private var startOffset: CGFloat = 0.0
    @State private var scrollYOffset: CGFloat = 0.0
    
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AnalysisTopBarView(scrollYOffset: $scrollYOffset)
                    
                AnalysisScrollView(scrollYOffset: $scrollYOffset)
            }
        }
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
    }
}
