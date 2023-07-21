//
//  AnalysisScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/14/23.
//

import SwiftUI
import Charts
import RealmSwift

@available(iOS 17.0, *)
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

@available(iOS 17.0, *)
extension AnalysisScrollView {
    var analysisScrollContent: some View {
        TrackableVerticalScrollView(yOffset: $analysisViewData.scrollYOffset) {
            analysisTabGroup
        }
        .scrollIndicators(.hidden)
        .padding([.leading, .top, .trailing])
        .padding(.bottom, 40)
        .background(Color(.background))
    }
    
    var analysisTabGroup: some View {
        VStack(spacing: 20) {
            AnalysisChartsTabView()
            
            AnalysisHighlightTabView()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    AnalysisScrollView()
        .environmentObject(AnalysisViewData())
}
