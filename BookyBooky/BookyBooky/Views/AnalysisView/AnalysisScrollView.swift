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
    
    @ObservedResults(CompleteBook.self) var readingBooks
    
    @State private var startOffset: CGFloat = 0.0
    
    // MARK: - PROPERTIES
    
    @Binding var scrollYOffset: CGFloat
    
    // MARK: - BODY
    
    var body: some View {
        analysisScrollContent
    }
}

// MARK: - EXTENSIONS

extension AnalysisScrollView {
    var analysisScrollContent: some View {
        ScrollView {
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
        .trackScrollYOffet($startOffset, yOffset: $scrollYOffset)
    }
}

#Preview {
    AnalysisScrollView(scrollYOffset: .constant(0.0))
}
