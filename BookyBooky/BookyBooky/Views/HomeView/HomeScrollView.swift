//
//  HomeScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/20.
//

import SwiftUI
import RealmSwift

// 리팩토링 필요

struct HomeScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var startOffset: CGFloat = 0.0
    
    // MARK: - PROPERTIES
    
    @Binding var scrollYOffset: CGFloat
    @Binding var selectedBookSortCriteria: BookSortCriteria
    
    // MARK: - INTIALIZER
    
    init(scrollYOffset: Binding<CGFloat>,
         selectedBookSortCriteria: Binding<BookSortCriteria>) {
        self._scrollYOffset = scrollYOffset
        self._selectedBookSortCriteria = selectedBookSortCriteria
    }
    
    // MARK: - BODY
    
    var body: some View {
        scrollContent
    }
}

// MARK: - EXTENSION

extension HomeScrollView {
    var scrollContent: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    VStack {
                        navigationBarTitle
                        
                        HomeActivityTabView()
                        
                        HomeReadingBookTabView(
                            scrollYOffset: $scrollYOffset,
                            selectedBookSortCriteria: $selectedBookSortCriteria,
                            scrollProxy: scrollProxy
                        )
                    }
                    .scrollYOffet($startOffset, scrollYOffset: $scrollYOffset)
                }
            }
        }
    }
    
    var navigationBarTitle: some View {
        VStack(alignment: .leading) {
            navigationSubTitle
            
            navigationMainTitle
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
    
    var navigationSubTitle: some View {
        Text(Date().toFormat("M월 d일 E요일"))
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .opacity(scrollYOffset > 10 ? 0 : 1)
    }
    
    var navigationMainTitle: some View {
        Text("홈")
            .font(.system(size: 34 + getNavigationTitleFontSizeOffset(scrollYOffset)))
            .fontWeight(.bold)
            .minimumScaleFactor(0.001)
    }
}

// MARK: - PREVIEW

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScrollView(
            scrollYOffset: .constant(0.0),
            selectedBookSortCriteria: .constant(.titleAscendingOrder)
        )
        .environmentObject(RealmManager())
    }
}
