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
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    @State private var startOffset: CGFloat = 0.0
    
    // MARK: - PROPERTIES
    
    @Binding var scrollYOffset: CGFloat
    
    // MARK: - BODY
    
    var body: some View {
        analysisScroll
    }
}

// MARK: - EXTENSIONS

extension AnalysisScrollView {
    var analysisScroll: some View {
        ScrollView {
            analysisContent
        }
        .scrollIndicators(.hidden)
        .safeAreaPadding([.leading, .top, .trailing])
        .safeAreaPadding(.bottom, 40)
        .background(Color(.background))
    }
    
    var analysisContent: some View {
        VStack(spacing: 20) {
            AnalysisChartsTabView()
            
            AnalysisHighlightTabView()
        }
        .overlay(alignment: .top) {
            GeometryReader { proxy -> Color in
                DispatchQueue.main.async {
                    let offset = proxy.frame(in: .global).minY
                    if startOffset == 0 {
                        self.startOffset = offset
                    }
                    withAnimation(.easeInOut(duration: 0.1)) {
                        scrollYOffset = startOffset - offset
                    }
                    
                    print(scrollYOffset)
                }
                return Color.clear
            }
            .frame(width: 0, height: 0)
        }
    }
}

#Preview {
    AnalysisScrollView(scrollYOffset: .constant(0.0))
}
