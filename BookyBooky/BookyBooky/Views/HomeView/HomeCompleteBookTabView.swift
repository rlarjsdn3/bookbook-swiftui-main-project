//
//  HomeMainReadingBookView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/17.
//

import SwiftUI
import RealmSwift
import DeviceKit

struct HomeCompleteBookTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(CompleteBook.self) var compBooks
    
    @State private var selectedCategory: Category = .all
    @State private var selectedCategoryForAnimation: Category = .all
    
    @Namespace var namespace
    
    // MARK: - PROPERTIES
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var scrollYOffset: CGFloat
    @Binding var selectedBookSort: BookSortCriteria
    let scrollProxy: ScrollViewProxy
    
    // MARK: - COMPUTED PROPERTIES
    
    var dynamicBottomPaddingValue: CGFloat {
        let filteredUnfinishedBooksCount = compBooks.getFilteredReadingBooks(
            .unfinished, sort: selectedBookSort, category: selectedCategory
        ).count
        
        switch filteredUnfinishedBooksCount {
        case _ where filteredUnfinishedBooksCount <= 2:
            // iPhone 12Pro 기준, 하단 패딩 값
            // 추후 스크린 사이즈(기기) 별로 별도 다른 하단 패딩 값을 부여해야 함
            return mainScreen.height * 0.39
        case _ where filteredUnfinishedBooksCount <= 4:
            // iPhone 12Pro 기준, 하단 패딩 값
            // 추후 스크린 사이즈(기기) 별로 별도 다른 하단 패딩 값을 부여해야 함
            return mainScreen.height * 0.04
        default:
            return 0
        }
    }
    
    // MARK: - INTIALIZER
    
    init(scrollYOffset: Binding<CGFloat>,
         selectedBookSortCriteria: Binding<BookSortCriteria>,
         scrollProxy: ScrollViewProxy) {
        self._scrollYOffset = scrollYOffset
        self._selectedBookSort = selectedBookSortCriteria
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        compBooksTab
    }
}

// MARK: - EXTENSIONS

extension HomeCompleteBookTabView {
    var compBooksTab: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            tabTitle
            
            Section {
                tabContent
            } header: {
                categoryButtonGroup(scrollProxy: scrollProxy)
            }
        }
    }
    
    var tabTitle: some View {
        HStack {
            headlineText
            
            utilMenu
        }
        .padding(.top, 10)
        .padding(.bottom, -10)
    }
    
    var headlineText: some View {
        Text("독서")
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
    }
    
    var utilMenu: some View {
        Menu {
            Section {
                sortButtonGroup
                
                // TODO: - 읽고 있는 도서 리스트를 '격자 모드' 혹은 '리스트 모드'로 보게 만들기 (버전 1.1)
            } header: {
                Text("도서 정렬")
            }
        } label: {
            ellipsisSFSymbolImage
        }
    }
    
    var ellipsisSFSymbolImage: some View {
        Image(systemName: "ellipsis.circle.fill")
            .font(.title2)
            .foregroundColor(.black)
            .navigationBarItemStyle()
    }
    
    var sortButtonGroup: some View {
        ForEach(BookSortCriteria.allCases) { criteria in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            selectedBookSort = criteria
                        }
                        HapticManager.shared.impact(.rigid)
                    }
                }
            } label: {
                Text(criteria.name)
                if selectedBookSort == criteria {
                    Text("적용됨")
                }
            }
        }
    }
    
    var tabContent: some View {
        Group {
            let readingBook = compBooks.get(.unfinished)
            
            if readingBook.isEmpty {
                noReadingBookLabel
            } else {
                compBookButtonGroup
            }
        }
    }
    
    var noReadingBookLabel: some View {
        VStack(spacing: 5) {
            Text("읽고 있는 도서가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("도서를 추가하십시오.")
                .foregroundColor(.secondary)
        }
        .padding(.top, 50)
    }
    
    var compBookButtonGroup: some View {
        Group {
            let filterReadingBooks = compBooks.getFilteredReadingBooks(
                .unfinished,
                sort: selectedBookSort,
                category: selectedCategory
            )
            
            // TODO: - 읽고 있는 도서 리스트를 '격자 모드' 혹은 '리스트 모드'로 보게 만들기 (버전 1.1)
            
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(filterReadingBooks) { readingBook in
                    CompleteBookButton(readingBook, type: .home)
                }
            }
            .safeAreaPadding([.leading, .top, .trailing])
            .safeAreaPadding(.bottom, dynamicBottomPaddingValue)
        }
    }
    
    func categoryButtonGroup(scrollProxy proxy: ScrollViewProxy) -> some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    let categories = compBooks.get(.unfinished).getReadingBookCategoryType()
                    
                    ForEach(categories, id: \.self) { category in
                        HomeCategoryButton(
                            category,
                            selectedCategoryType: $selectedCategory,
                            selectedCategoryTypeForAnimation: $selectedCategoryForAnimation,
                            scrollProxy: proxy,
                            namespace: namespace
                        )
                        .id("\(category.rawValue)")
                    }
                }
                .padding(.vertical, 10)
                .padding([.horizontal, .bottom], 5)
            }
            .id("Scroll_To_Category")
        }
        .background(.white)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

// MARK: - PREVIEW

struct HomeReadingBookTabView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            HomeCompleteBookTabView(
                scrollYOffset: .constant(0.0),
                selectedBookSortCriteria: .constant(.titleAscendingOrder),
                scrollProxy: scrollProxy
            )
            .environmentObject(RealmManager())
        }
    }
}
