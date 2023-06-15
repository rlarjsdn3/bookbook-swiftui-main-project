//
//  HomeMainReadingBookView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/17.
//

import SwiftUI
import RealmSwift
import DeviceKit

struct HomeReadingBookTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    @State private var selectedCategory: CategoryType = .all
    @State private var selectedCategoryForAnimation: CategoryType = .all
    
    @Namespace var namespace
    
    // MARK: - PROPERTIES
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var scrollYOffset: CGFloat
    @Binding var selectedBookSortCriteria: BookSortCriteria
    let scrollProxy: ScrollViewProxy
    
    // MARK: - COMPUTED PROPERTIES
    
    var dynamicBottomPaddingValue: CGFloat {
        return 300.0
    }
    
    // MARK: - INTIALIZER
    
    init(scrollYOffset: Binding<CGFloat>,
         selectedBookSortCriteria: Binding<BookSortCriteria>,
         scrollProxy: ScrollViewProxy) {
        self._scrollYOffset = scrollYOffset
        self._selectedBookSortCriteria = selectedBookSortCriteria
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        readingBookTab
    }
}

// MARK: - EXTENSIONS

extension HomeReadingBookTabView {
    var readingBookTab: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            readingBookTabTitle
            
            Section {
                readingBookTabContent
            } header: {
                categoryButtons(scrollProxy: scrollProxy)
            }
        }
    }
    
    var readingBookTabTitle: some View {
        HStack {
            readingBookHeadlineText
            
            utilMenu
        }
        .padding(.bottom, -10)
    }
    
    var readingBookHeadlineText: some View {
        Text("독서")
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
    }
    
    var utilMenu: some View {
        Menu {
            Section {
                sortButtons
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
    
    var sortButtons: some View {
        ForEach(BookSortCriteria.allCases) { criteria in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            selectedBookSortCriteria = criteria
                        }
                        HapticManager.shared.impact(.rigid)
                    }
                }
            } label: {
                Text(criteria.name)
                if selectedBookSortCriteria == criteria {
                    Text("적용됨")
                }
            }
        }
    }
    
    var readingBookTabContent: some View {
        Group {
            let readingBook = readingBooks.get(.unfinished)
            
            if readingBook.isEmpty {
                noBookIsBeingReadLabel
            } else {
                readingBookButtons
            }
        }
    }
    
    var noBookIsBeingReadLabel: some View {
        VStack(spacing: 5) {
            Text("읽고 있는 도서가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("도서를 추가하십시오.")
                .foregroundColor(.secondary)
        }
        .padding(.top, 50)
    }
    
    var readingBookButtons: some View {
        Group {
            let filterReadingBooks = readingBooks.getFilteredReadingBooks(
                .unfinished,
                sort: selectedBookSortCriteria,
                category: selectedCategory
            )
            
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(filterReadingBooks) { readingBook in
                    ReadingBookButton(readingBook, buttonType: .home)
                }
            }
            .padding(.bottom, dynamicBottomPaddingValue)
            .safeAreaPadding()
        }
    }
    
    func categoryButtons(scrollProxy proxy: ScrollViewProxy) -> some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    let categories = readingBooks.get(.unfinished).getReadingBookCategoryType()
                    
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
            HomeReadingBookTabView(
                scrollYOffset: .constant(0.0),
                selectedBookSortCriteria: .constant(.titleAscendingOrder),
                scrollProxy: scrollProxy
            )
            .environmentObject(RealmManager())
        }
    }
}
