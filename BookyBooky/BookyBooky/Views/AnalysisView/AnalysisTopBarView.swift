//
//  AnalysisTopBarView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/14/23.
//

import SwiftUI

struct AnalysisTopBarView: View {
    @Binding var scrollYOffset: CGFloat
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("분석")
                .navigationTitleStyle()
            
            Spacer()
        }
        .padding(.vertical)
        .overlay(alignment: .bottom) {
            if scrollYOffset > 15.0 {
                Divider()
            }
        }
    }
}

#Preview {
    AnalysisTopBarView(scrollYOffset: .constant(0.0))
}
