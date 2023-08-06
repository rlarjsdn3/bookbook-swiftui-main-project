//
//  AnalysisView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/20.
//

// NOTICE: - 본 파일에 구현된 기능은 아직 미완성입니다.

import SwiftUI
import Charts
import RealmSwift

@available(iOS 17.0, *)
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

@available(iOS 17.0, *)
struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
    }
}
