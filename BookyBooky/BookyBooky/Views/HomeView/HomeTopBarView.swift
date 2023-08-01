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
    
    @ObservedResults(CompleteBook.self) var compBooks
    
    @State private var isPresentingSettingsView = false
    @State private var isPresentingSearchSheetView = false
    
    // MARK: - COMPUTED PROPERTIES
    
    var recentActivityCount: Int {
        compBooks.recentReadingActivity.count
    }
    
    var showingTopBarDividerYPositionValue: CGFloat {
        if recentActivityCount == 0 {
            return CGFloat(215.0)
        } else {
            return CGFloat(120 + (70 * recentActivityCount))
        }
    }
    
    var showingUtilMenuYPositionValue: CGFloat {
        if recentActivityCount == 0 {
            return CGFloat(293.0)
        } else {
            return CGFloat(158 + (70 * recentActivityCount))
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
            navigationTopBarButtonGroup
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
    
    var navigationTopBarButtonGroup: some View {
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
                    utilMenu
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
    
    var utilMenu: some View {
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
                    HapticManager.shared.impact(.rigid)
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

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTopBarView()
            .environmentObject(HomeViewData())
    }
}
