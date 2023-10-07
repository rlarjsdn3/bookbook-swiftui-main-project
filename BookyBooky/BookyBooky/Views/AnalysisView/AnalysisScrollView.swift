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
        .background(Color.customBackground)
    }
    
    var analysisTabGroup: some View {
        VStack(spacing: 20) {
            AnalysisChartsSectionView()
            
            AnalysisHighlightSectionView()
        }
        .padding([.leading, .top, .trailing])
        .padding(.bottom, 40)
    }
}

struct AnalysisScrollView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisScrollView()
            .environmentObject(AnalysisViewData())
    }
}
