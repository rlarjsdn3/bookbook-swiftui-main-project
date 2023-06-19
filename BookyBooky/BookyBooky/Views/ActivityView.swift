//
//  ActivityView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/12.
//

import SwiftUI
import RealmSwift

struct ActivityView: View {
    
    // MARK: - WRAPPER RPOPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ActivityTopBarView()
                
                ActivityScrollView()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - PREVIEW

#Preview {
    ActivityView()
}
