//
//  AnalysisView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/20.
//

import SwiftUI
import Charts
import RealmSwift

struct AnalysisView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(CompleteBook.self) var compBooks

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

// MARK: - PREVIEW

#Preview {
    AnalysisView()
}
