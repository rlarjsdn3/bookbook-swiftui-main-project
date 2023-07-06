//
//  AnalysisScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/14/23.
//

import SwiftUI
import Charts
import RealmSwift

struct AnalysisScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var analysisViewData: AnalysisViewData
    
    @ObservedResults(CompleteBook.self) var readingBooks
    
    // MARK: - BODY
    
    var body: some View {
        analysisScrollContent
    }
}

// MARK: - EXTENSIONS

extension AnalysisScrollView {
    var analysisScrollContent: some View {
        TrackableVerticalScrollView(yOffset: $analysisViewData.scrollYOffset) {
            analysisTabGroup
        }
        .scrollIndicators(.hidden)
        .safeAreaPadding([.leading, .top, .trailing])
        .safeAreaPadding(.bottom, 40)
        .background(Color(.background))
    }
    
    var analysisTabGroup: some View {
        VStack(spacing: 20) {
            AnalysisChartsTabView()
            
            AnalysisHighlightTabView()
        }
    }
}

#Preview {
    AnalysisScrollView()
        .environmentObject(AnalysisViewData())
}
