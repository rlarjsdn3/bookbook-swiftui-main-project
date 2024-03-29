//
//  AnalysisTopBarView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/14/23.
//

import SwiftUI

struct AnalysisTopBarView: View {
    
    // MARK: - PROPERTIES
    
    @EnvironmentObject var analysisViewData: AnalysisViewData
    
    // MARK: - BODY
    
    var body: some View {
        navigationTopBar
    }
}

// MARK: - EXTENSIONS

extension AnalysisTopBarView {
    var navigationTopBar: some View {
        HStack {
            Spacer()
            
            Text("분석")
                .navigationTitleStyle()
            
            Spacer()
        }
        .padding(.vertical)
        .overlay(alignment: .bottom) {
            if analysisViewData.scrollYOffset > 10.0 {
                Divider()
            }
        }
    }
}

// MARK: - PREVIEW

struct AnalysisTopBarView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisTopBarView()
            .environmentObject(AnalysisViewData())
    }
}
