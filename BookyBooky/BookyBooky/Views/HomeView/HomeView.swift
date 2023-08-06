//
//  HomeView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @StateObject var homeViewData = HomeViewData()
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HomeTopBarView()
                
                HomeScrollView()
            }
            .environmentObject(homeViewData)
        }
    }
}

// MARK: - PREVIEW

struct HeomView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
