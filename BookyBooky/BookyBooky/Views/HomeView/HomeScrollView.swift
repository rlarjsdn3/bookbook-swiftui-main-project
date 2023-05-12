//
//  HomeScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/20.
//

import SwiftUI
import RealmSwift

struct HomeScrollView: View {
    
    let COVER_HEGHT_RATIO = 0.18        // 화면 사이즈 대비 표지(커버) 이미지 높이 비율
    let BACKGROUND_HEIGHT_RATIO = 0.3   // 화면 사이즈 대비 바탕 색상 높이 비율
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    // 애니메이션 / 애니메이션 없는 변수 구분하기
    @State private var selectedCategory: Category = .all
    @State private var selectedAnimation: Category = .all
    
    @State private var isLoading = true
    
    @State private var isPresentingReadingBookView = false
    
    @State private var startOffset = 0.0
    
    @Binding var selectedSort: BookSort
    @Binding var scrollYOffset: Double
    
    @Namespace var underlineAnimation
    
    // MARK: - COMPUTED PROPERTIES
    
    var categories: [Category] {
        var categories: [Category] = [.all]
        
        for book in readingBooks where !categories.contains(book.category) {
            categories.append(book.category)
        }
        
        return categories
    }
    
    var sortedReadingBooks: [ReadingBook] {
        switch selectedSort {
        // 최근 추가된 순으로 정렬
        case .latestOrder:
            return readingBooks.reversed()
        // 제목 오름차순으로 정렬
        case .titleOrder:
            return readingBooks.sorted { $0.title < $1.title }
        // 판매 포인트 내림차순으로 정렬
        case .authorOrder:
            return readingBooks.sorted { $0.author > $1.author }
        }
    }
    
    var filteredReadingBooks: [ReadingBook] {
        var filteredBooks: [ReadingBook] = []
        
        // 애니메이션이 없는 변수로 코드 수정하기
        if selectedCategory == .all {
            return Array(sortedReadingBooks)
        } else {
            for book in sortedReadingBooks where selectedCategory == book.category {
                filteredBooks.append(book)
            }
            
            return filteredBooks
        }
    }
    
    var prefix3Activity: [Activity] {
        var activity: [Activity] = []
        
        readingBooks.forEach { readingBook in
            readingBook.readingRecords.forEach { record in
                activity.append(
                    Activity(date: record.date, title: readingBook.title, author: readingBook.author, category: readingBook.category, itemPage: readingBook.itemPage, isbn13: readingBook.isbn13,  numOfPagesRead: record.numOfPagesRead, totalPagesRead: record.totalPagesRead)
                )
                
            }
        }
        
        activity.sort { $0.date > $1.date }
        
        return Array(activity.prefix(min(3, activity.count)))
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        navigationTitle
                        
                        // 미완성 코드
                        
                        HStack {
                            activityHeadlineLabel
                            
                            Spacer()
                            
                            NavigationLink("더 보기") {
                                ActivityView()
                            }
                            .padding(.trailing, 25)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // 활동 스크롤 코드
                        ScrollView {
                            ForEach(prefix3Activity, id: \.self) { activity in
                                ActivityCellView(activity: activity)
                            }
                        }
                        
                        //
                        
                        HStack {
                            targetBookHeadlineLabel
                            
                            targetBookSortMenu
                        }
                        .padding(.bottom, -10)
                        
                        
                        Section {
                            targetBookLazyGrid
                        } header: {
                            targetBookPinnedLabel(scrollProxy: scrollProxy)
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
    
    /// 스크롤의 최상단 Y축 좌표의 위치에 따라 폰트의 추가 사이즈를 반환하는 함수입니다.
    func getFontSizeOffset() -> CGFloat {
        let START_yOFFSET = 20.0 // 폰트 크기가 커지기 시작하는 Y축 좌표값
        let END_yOFFSET = 130.0  // 폰트 크기가 최대로 커진 Y축 좌표값
        let SCALE = 0.03         // Y축 좌표값에 비례하여 커지는 폰트 크기의 배수
        
        // Y축 좌표가 START_yOFFSET 이상이라면
        if -scrollYOffset > START_yOFFSET {
            // Y축 좌표가 END_yOFFSET 미만이라면
            if -scrollYOffset < END_yOFFSET {
                return -scrollYOffset * SCALE // 현재 최상단 Y축 좌표의 SCALE배만큼 추가 사이즈 반환
            // Y축 좌표가 END_yOFFSET 이상이면
            } else {
                return END_yOFFSET * SCALE // 폰트의 최고 추가 사이즈 반환
            }
        }
        // Y축 좌표가 START_yOFFSET 미만이라면
        return 0.0 // 폰트 추가 사이즈 없음
    }
}

extension HomeScrollView {
    var navigationTitle: some View {
        VStack(alignment: .leading) {
            navigationDateSubTitle
            
            navigationHomeMainTitle
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
    
    var navigationDateSubTitle: some View {
        Text(Date().toFormat("M월 d일 E요일"))
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .opacity(scrollYOffset > 10 ? 0 : 1)
    }
    
    var navigationHomeMainTitle: some View {
        Text("홈")
            .font(.system(size: 34 + getFontSizeOffset()))
            .fontWeight(.bold)
            .minimumScaleFactor(0.001)
    }
    
    var activityHeadlineLabel: some View {
        Text("활동")
            .font(.title2)
            .fontWeight(.bold)
            .padding(.leading, 15)
    }
    
    var targetBookHeadlineLabel: some View {
        Text("독서")
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
    }
    
    var targetBookSortMenu: some View {
        Menu {
            Section {
                sortButtons
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
    
    var sortButtons: some View {
        ForEach(BookSort.allCases, id: \.self) { sort in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 곧바로 스크롤을 제일 위로 올리고
//                    scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            selectedSort = sort
                        }
                        HapticManager.shared.impact(.rigid)
                    }
                }
            } label: {
                HStack {
                    Text(sort.rawValue)
                    
                    // 현재 선택한 정렬 타입에 체크마크 표시
                    if selectedSort == sort {
                        checkmark
                    }
                }
            }
        }
    }
    
    var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.title3)
    }
    
    var targetBookLazyGrid: some View {
        Group {
            if readingBooks.isEmpty {
                VStack(spacing: 5) {
                    Text("읽고 있는 도서가 없음")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("도서를 추가하십시오.")
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
            } else {
                LazyVGrid(columns: columns, spacing: 25) {
                    ForEach(filteredReadingBooks) { book in
                        ReadingBookCellView(readingBook: book)
                    }
                }
                .padding([.horizontal, .top])
                // 코드 수정할 필요가 있음(직관적으로 수정하기 혹은 주석 설명 달기)
                .padding(.bottom, filteredReadingBooks.count <= 2 ? (mainScreen.height > 900 ? 400 : mainScreen.height < 700 ? 190 : 325) : (mainScreen.height > 900 ? 100 : 30))
            }
        }
    }
    
    func targetBookPinnedLabel(scrollProxy proxy: ScrollViewProxy) -> some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories, id: \.self) { category in
                        HomeCategoryButtonsView(
                            category: category,
                            selectedCategory: $selectedCategory,
                            selectedAnimation: $selectedAnimation,
                            scrollProxy: proxy,
                            underlineAnimation: underlineAnimation
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
                .opacity(scrollYOffset > 30 ? 1 : 0)
        }
    }
}

struct HomeScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScrollView(selectedSort: .constant(.latestOrder), scrollYOffset: .constant(0.0))
    }
}
