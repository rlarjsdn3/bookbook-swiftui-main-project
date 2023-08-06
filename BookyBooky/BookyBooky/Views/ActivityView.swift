//
//  ActivityView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/12.
//

import SwiftUI

struct ActivityView: View {
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            ActivityTopBarView()
            
            ActivityScrollView()
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - PREVIEW

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
