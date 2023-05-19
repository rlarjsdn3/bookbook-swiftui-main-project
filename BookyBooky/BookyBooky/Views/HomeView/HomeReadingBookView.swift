//
//  HomeMainReadingBookView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/17.
//

import SwiftUI
import RealmSwift

struct HomeReadingBookView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    @State private var selectedCategoryType: CategoryTypes = .all
    @State private var selectedCategoryTypeForAnimation: CategoryTypes = .all
    
    @Namespace var namespace
    
    // MARK: - PROPERTIES
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var scrollYOffset: Double
    @Binding var selectedBookSortType: BookSortCriteriaTypes
    let scrollProxy: ScrollViewProxy
    
    // MARK: - INTIALIZER
    
    init(_ scrollYOffset: Binding<Double>,
         selectedBookSortType: Binding<BookSortCriteriaTypes>, scrollProxy: ScrollViewProxy) {
        self._scrollYOffset = scrollYOffset
        self._selectedBookSortType = selectedBookSortType
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        readingBookTab
    }
}

// MARK: - EXTENSIONS

extension HomeReadingBookView {
    var readingBookTab: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            readingBookTabTitle
            
            Section {
                readingBookTabContent
            } header: {
                readingBookCategoryButtons(scrollProxy: scrollProxy)
            }
        }
    }
    
    var readingBookTabTitle: some View {
        HStack {
            readingBookHeadlineText
            
            readingBookSortMenu
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
    
    var readingBookSortMenu: some View {
        Menu {
            Section {
                bookSortMenuButtons
            } header: {
                Text("도서 정렬")
            }
        } label: {
            ellipsisSFSymbolImage
        }
        .navigationBarItemStyle()
    }
    
    var ellipsisSFSymbolImage: some View {
        Image(systemName: "ellipsis.circle.fill")
            .font(.title2)
            .foregroundColor(.black)
    }
    
    var bookSortMenuButtons: some View {
        ForEach(BookSortCriteriaTypes.allCases, id: \.self) { type in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            selectedBookSortType = type
                        }
                        HapticManager.shared.impact(.rigid)
                    }
                }
            } label: {
                bookSortMenuButtonLabel(type)
            }
        }
    }
    
    func bookSortMenuButtonLabel(_ type: BookSortCriteriaTypes) -> some View {
        HStack {
            Text(type.rawValue)
            
            // 현재 선택한 정렬 타입에 체크마크 표시
            if selectedBookSortType == type {
                checkMarkSFSymbolImage
            }
        }
    }
    
    var checkMarkSFSymbolImage: some View {
        Image(systemName: "checkmark")
            .font(.title3)
    }
    
    var readingBookTabContent: some View {
        Group {
            let readingBook = readingBooks.get(.unfinished)
            
            if readingBook.isEmpty {
                noBookIsBeingReadLabel
            } else {
                readingBookGrid
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
    
    var readingBookGrid: some View {
        Group {
            // 이렇게 해서 DB 내 데이터가 바뀌거나 추가될 때마다 뷰를 새로 그려지게 해야 한다! <- 이거 중요
            let filterReadingBooks = readingBooks.getfilteredReadingBooks(
                bookSortType: selectedBookSortType,
                categoryType: selectedCategoryType
            )
            
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(filterReadingBooks) { book in
                    ReadingBookCellButton(book, buttonType: .home)
                }
            }
            .padding([.horizontal, .top])
            // 코드 수정할 필요가 있음(직관적으로 수정하기 혹은 주석 설명 달기)
            .padding(.bottom,
                     filterReadingBooks.count <= 2 ?
                     (mainScreen.height > 900 ? 400 : mainScreen.height < 700 ? 190 : 325) : (mainScreen.height > 900 ? 100 : 30))
        }
    }
    
    func readingBookCategoryButtons(scrollProxy proxy: ScrollViewProxy) -> some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    let filterReadingBooks = readingBooks.getfilteredReadingBooks(
                        bookSortType: selectedBookSortType,
                        categoryType: selectedCategoryType
                    )
                    
                    ForEach(filterReadingBooks.getReadingBookCategoryType(), id: \.self) { type in
                        HomeCategoryButton(
                            type,
                            selectedCategoryType: $selectedCategoryType,
                            selectedCategoryTypeForAnimation: $selectedCategoryTypeForAnimation,
                            scrollProxy: proxy,
                            namespace: namespace
                        )
                        .id("\(type.rawValue)")
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
                .opacity(scrollYOffset > 30 ? 1 : 0)
        }
    }
}

// MARK: - PREVIEW

struct HomeReadingBookTabView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            HomeReadingBookView(.constant(0.0),
                                   selectedBookSortType: .constant(.latestOrder),
                                   scrollProxy: scrollProxy)
                .environmentObject(RealmManager())
        }
    }
}
