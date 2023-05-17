//
//  HomeScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/20.
//

import SwiftUI
import RealmSwift

// 리팩토링 필요

struct HomeMainView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var startOffset = 0.0
    
    @State private var selectedCategoryType: CategoryTypes = .all
    @State private var selectedCategoryTypeForAnimation: CategoryTypes = .all
    
    @Namespace var namespace
    
    // MARK: - PROPERTIES
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var scrollYOffset: Double
    @Binding var selectedBookSortType: BookSortCriteriaType
    
    // MARK: - INTIALIZER
    
    init(_ scrollYOffset: Binding<Double>, selectedBookSortType: Binding<BookSortCriteriaType>) {
        self._scrollYOffset = scrollYOffset
        self._selectedBookSortType = selectedBookSortType
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        navigationBarTitle
                        
                        HomeActivitySectionView()
                        
                        // 활동 섹션 뷰 - 파일 분리
                        
                        // 읽은 도서 섹션 뷰 - 파일 분리
                        
                        HStack {
                            targetBookHeadlineText
                            
                            readingBookSortMenu
                        }
                        .padding(.bottom, -10)
                        
                        
                        Section {
                            readingBookScrollView
                        } header: {
                            readingBookCategoryButtons(scrollProxy: scrollProxy)
                        }
                    }
                    .overlay(alignment: .top) {
                        GeometryReader { proxy -> Color in
                            DispatchQueue.main.async {
                                let offset = proxy.frame(in: .global).minY
                                if startOffset == 0 {
                                    self.startOffset = offset
                                }
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    scrollYOffset = startOffset - offset
                                }
                                
                                print(scrollYOffset)
                            }
                            return Color.clear
                        }
                        .frame(width: 0, height: 0)
                    }
                }
            }
        }
    }
}

// MARK: - EXTENSION

extension HomeMainView {
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
    
    var targetBookHeadlineText: some View {
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
        ForEach(BookSortCriteriaType.allCases, id: \.self) { type in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 곧바로 스크롤을 제일 위로 올리고
//                    scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
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
    
    func bookSortMenuButtonLabel(_ type: BookSortCriteriaType) -> some View {
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
    
    var readingBookScrollView: some View {
        Group {
            let readingBook = realmManager.getReadingBooks(isComplete: false)
            
            if readingBook.isEmpty {
                noBookIsBeingReadLabel
            } else {
                let filterReadingBookArray = realmManager.filterReadingBookArray(
                    bookSortType: selectedBookSortType,
                    categoryType: selectedCategoryType
                )
                
                LazyVGrid(columns: columns, spacing: 25) {
                    ForEach(filterReadingBookArray) { book in
                        ReadingBookCellButton(readingBook: book, cellType: .home)
                    }
                }
                .padding([.horizontal, .top])
                // 코드 수정할 필요가 있음(직관적으로 수정하기 혹은 주석 설명 달기)
                .padding(.bottom, filterReadingBookArray.count <= 2 ? (mainScreen.height > 900 ? 400 : mainScreen.height < 700 ? 190 : 325) : (mainScreen.height > 900 ? 100 : 30))
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
    
    func readingBookCategoryButtons(scrollProxy proxy: ScrollViewProxy) -> some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(realmManager.getReadingBookCategoryType(), id: \.self) { type in
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

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView(.constant(0.0), selectedBookSortType: .constant(.latestOrder))
            .environmentObject(RealmManager())
    }
}
