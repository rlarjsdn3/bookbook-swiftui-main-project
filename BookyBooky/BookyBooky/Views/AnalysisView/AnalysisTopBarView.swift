//
//  AnalysisTopBarView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/14/23.
//

// NOTICE: - 본 파일에 구현된 기능은 아직 미완성입니다.

import SwiftUI

@available(iOS 17.0, *)
struct AnalysisTopBarView: View {
    
    // MARK: - PROPERTIES
    
    @EnvironmentObject var analysisViewData: AnalysisViewData
    
    // MARK: - BODY
    
    var body: some View {
        navigationTopBar
    }
}

// MARK: - EXTENSIONS

@available(iOS 17.0, *)
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

@available(iOS 17.0, *)
struct AnalysisTopBarView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisTopBarView()
            .environmentObject(AnalysisViewData())
    }
}
