//
//  HomeView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            HomeHeaderView()
            
            Spacer()
        }
    }
}

// MARK: - PREVIEW

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
