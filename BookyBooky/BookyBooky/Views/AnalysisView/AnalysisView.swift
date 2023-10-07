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
    
    @StateObject var analysisViewData = AnalysisViewData()
    
    @ObservedResults(CompleteBook.self) var compBooks
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AnalysisTopBarView()
                    
                AnalysisScrollView()
            }
            .environmentObject(analysisViewData)
        }
    }
}

// MARK: - PREVIEW

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
    }
}
