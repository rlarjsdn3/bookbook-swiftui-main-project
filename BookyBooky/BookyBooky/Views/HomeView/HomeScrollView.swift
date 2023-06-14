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
    @Binding var selectedBookSortType: BookSortCriteriaType
    
    // MARK: - INTIALIZER
    
    init(_ scrollYOffset: Binding<CGFloat>, selectedBookSortType: Binding<BookSortCriteriaType>) {
        self._scrollYOffset = scrollYOffset
        self._selectedBookSortType = selectedBookSortType
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    VStack {
                        navigationBarTitle
                        
                        HomeActivityTabView()
                        
                        HomeReadingBookTabView(
                            $scrollYOffset,
                            selectedBookSortType: $selectedBookSortType,
                            scrollProxy: scrollProxy
                        )
                    }
                    .scrollYOffet($startOffset, scrollYOffset: $scrollYOffset)
                }
            }
        }
    }
}

// MARK: - EXTENSION

extension HomeScrollView {
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
        HomeScrollView(.constant(0.0), selectedBookSortType: .constant(.latestOrder))
            .environmentObject(RealmManager())
    }
}
