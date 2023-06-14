//
//  HomeView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var scrollYOffset: CGFloat = 0.0
    @State private var selectedBookSortType: BookSortCriteriaType = .latestOrder
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HomeHeaderView($scrollYOffset, selectedBookSortType: $selectedBookSortType)
                
                HomeScrollView($scrollYOffset, selectedBookSortType: $selectedBookSortType)
            }
        }
    }
}

// MARK: - PREVIEW

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
