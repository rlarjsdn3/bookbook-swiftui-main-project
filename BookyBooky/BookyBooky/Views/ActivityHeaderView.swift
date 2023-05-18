//
//  ActivityHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/18.
//

import SwiftUI

struct ActivityHeaderView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - BODY
    
    var body: some View {
        navigationBar
    }
}

// MARK: - EXTENSIONS

extension ActivityHeaderView {
    var navigationBar: some View {
        HStack {
            Spacer()
            
            navigationBarTitle

            Spacer()
        }
        .overlay {
            navigationBarButtons
        }
        .padding(.vertical)
    }
    
    var navigationBarTitle: some View {
        Text("활동")
            .navigationTitleStyle()
    }
    
    var navigationBarButtons: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .navigationBarItemStyle()
            }

            Spacer()
        }
    }
}


// MARK: - PREVIEW

struct ActivityHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityHeaderView()
    }
}
