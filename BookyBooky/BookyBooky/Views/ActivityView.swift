//
//  ActivityView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/12.
//

import SwiftUI
import RealmSwift

struct ActivityView: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            ActivityTopBarView()
            
            ActivityScrollView()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
