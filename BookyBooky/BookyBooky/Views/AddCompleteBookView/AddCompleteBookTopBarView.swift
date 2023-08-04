//
//  BookAddHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI

struct AddCompleteBookTopBarView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - PROPERTIES
    
    let title: String
    
    // MARK: - INTIALIZER
    
    init(title: String) {
        self.title = title
    }
    
    // MARK: - BODY
    
    var body: some View {
        navigationTopBar
    }
}

// MARK: - EXTENSIONS

extension AddCompleteBookTopBarView {
    var navigationTopBar: some View {
        HStack {
            backButton
            
            Spacer()
        }
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Label(title, systemImage: "chevron.left")
                .frame(width: mainScreen.width * 0.77, alignment: .leading)
                .lineLimit(1)
        }
        .navigationBarItemStyle()
        .padding(4)
    }
}

// MARK: - PREVIEW

#Preview {
    AddCompleteBookTopBarView(title: "자바의 정석")
}
