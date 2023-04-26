//
//  HomeView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct HomeView: View {
    
    @State private var scrollYOffset = 0.0
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            HomeHeaderView(scrollYOffset: $scrollYOffset)
            
            HomeScrollView(scrollYOffset: $scrollYOffset)
        }
    }
}

// MARK: - PREVIEW

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
