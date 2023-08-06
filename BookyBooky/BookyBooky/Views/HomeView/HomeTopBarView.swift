//
//  HomeHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI
import RealmSwift

struct HomeTopBarView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var homeViewData: HomeViewData
    
    @ObservedResults(CompleteBook.self) var readingBooks
    
    @State private var isPresentingSettingsView = false
    @State private var isPresentingSearchSheetView = false
    
    // MARK: - PROPERTIES
    
    let haptic = HapticManager()
    
    // MARK: - COMPUTED PROPERTIES
    
    var recentReadingActivityCount: Int {
        readingBooks.getActivity(prefix: 3).count
    }
    
    var showingTopBarDividerYPositionValue: CGFloat {
        if recentReadingActivityCount == 0 {
            return CGFloat(215)
        } else {
            return CGFloat(110 + (70 * recentReadingActivityCount))
        }
    }
    
    var showingUtilMenuYPositionValue: CGFloat {
        if recentReadingActivityCount == 0 {
            return CGFloat(282)
        } else {
            return CGFloat(142 + (70 * recentReadingActivityCount))
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        navigationTopBar
    }
}

// MARK: - EXTENSIONS

extension HomeTopBarView {
    var navigationTopBar: some View {
        HStack {
            Spacer()
            
            navigationTopBarTitle
            
            Spacer()
        }
        .sheet(isPresented: $isPresentingSettingsView) {
            ProfileView()
        }
        .sheet(isPresented: $isPresentingSearchSheetView) {
            SearchSheetView()
        }
        .padding(.vertical)
        .overlay {
            TopBarButtonGroup
        }
        .overlay(alignment: .bottom) {
            Divider()
                // scrollYOffset값이 10 ~ showingTopBarDivierYPositionValue 사이라면,
                // Divider를 보이게 합니다,
                .opacity(
                    (homeViewData.scrollYOffset > 10.0 &&
                     homeViewData.scrollYOffset < showingTopBarDividerYPositionValue) ? 1 : 0
                )
        }
    }
    
    var navigationTopBarTitle: some View {
        Text("홈")
            .navigationTitleStyle()
            .opacity(homeViewData.scrollYOffset > 35.0 ? 1 : 0)
    }
    
    var TopBarButtonGroup: some View {
        HStack {
            addReadingBookButton

            Spacer()
            
            profileButton
                // scrollYOffset값이 10 ~ showingUtilYPositionValue 사이라면,
                // SettingsButton을 숨기고, UtilMenu을 보이게 합니다.
                .opacity(
                    homeViewData.scrollYOffset < showingUtilMenuYPositionValue ? 1 : 0
                )
                .overlay {
                    bookSortMenu
                        .offset(
                            y: homeViewData.scrollYOffset < showingUtilMenuYPositionValue ? 5 : 0
                        )
                        .opacity(
                            homeViewData.scrollYOffset < showingUtilMenuYPositionValue ? 0 : 1
                        )
                    
                }
        }
    }
    
    var addReadingBookButton: some View {
        Button {
            isPresentingSearchSheetView = true
        } label: {
            plusSFSymbolImage
        }
    }
    
    var plusSFSymbolImage: some View {
        Image(systemName: "plus")
            .navigationBarItemStyle()
    }
    
    var profileButton: some View {
        Button {
            isPresentingSettingsView = true
        } label: {
            gearShapeSFSymbolImage
        }
    }
    
    var gearShapeSFSymbolImage: some View {
        Image(systemName: "gearshape.fill")
            .navigationBarItemStyle()
    }
    
    var bookSortMenu: some View {
        Menu {
            Section {
                sortButtonGroup
            } header: {
                Text("도서 정렬")
            }
        } label: {
            Image(systemName: "ellipsis.circle.fill")
                .font(.title2)
                .foregroundColor(.black)
        }
        .navigationBarItemStyle()
    }
    
    var sortButtonGroup: some View {
        ForEach(BookSortCriteria.allCases, id: \.self) { sort in
            Button {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                        homeViewData.selectedBookSort = sort
                    }
                    haptic.impact(.rigid)
                }
            } label: {
                Text(sort.name)
                if homeViewData.selectedBookSort == sort {
                    Text("적용됨")
                }
            }
        }
    }
}

// MARK: - PREVIEW

struct HomeTopBarView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTopBarView()
            .environmentObject(HomeViewData())
    }
}
