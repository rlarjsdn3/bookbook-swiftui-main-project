//
//  AnalysisView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/20.
//

import SwiftUI

struct AnalysisView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("분석")
                    .navigationTitleStyle()
                
                Spacer()
            }
            .padding(.vertical)
            
            Spacer()
        }
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
    }
}
