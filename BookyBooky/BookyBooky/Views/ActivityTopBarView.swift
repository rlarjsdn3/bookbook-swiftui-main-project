//
//  ActivityHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/18.
//

import SwiftUI

struct ActivityTopBarView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - BODY
    
    var body: some View {
        navigationTopBar
    }
}

// MARK: - EXTENSIONS

extension ActivityTopBarView {
    var navigationTopBar: some View {
        HStack {
            Spacer()
            
            navigationTopBarTitle

            Spacer()
        }
        .overlay {
            TopBarButtonGroup
        }
        .padding(.vertical)
    }
    
    var navigationTopBarTitle: some View {
        Text("활동")
            .navigationTitleStyle()
    }
    
    var TopBarButtonGroup: some View {
        HStack {
            Button {
                dismiss()
            } label: {
               chevronLeftSFSymbolImage
            }

            Spacer()
        }
    }
    
    var chevronLeftSFSymbolImage: some View {
        Image(systemName: "chevron.left")
            .navigationBarItemStyle()
    }
}


// MARK: - PREVIEW

struct ActivityHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTopBarView()
    }
}
