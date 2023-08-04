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
    
    @EnvironmentObject var homeViewData: HomeViewData
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(CompleteBook.self) var readingBooks
    
    @Namespace var namespace

    @State private var bookCategories: [Category] = []
    @State private var bookTappedCount = 0
    
    // MARK: - PROPERTIES
    
    let haptic = HapticManager()
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var defaultBottomPaddingValue: CGFloat = 30.0
    
    let scrollProxy: ScrollViewProxy
    
    // MARK: - COMPUTED PROPERTIES
    
    var filteredBooks: [CompleteBook] {
        var filteredBooks: [CompleteBook] = readingBooks.getFilteredReadingBooks(
            .unfinished,
            sort: homeViewData.selectedBookSort,
            category: homeViewData.selectedCategory
        )
        return filteredBooks
    }
    
    var dynamicBottomPaddingValue: CGFloat {
        let device = Device.current.realDevice
        
        switch getDeviceSceenSize(device) {
        case .device4_7inch where bookTappedCount <= 2:
            return 192.0 - defaultBottomPaddingValue
        case .device4_7inch where bookTappedCount <= 4:
            return 30.0 - defaultBottomPaddingValue // 기본 패딩 값
        case .device5_4inch where bookTappedCount <= 2:
            return 295.0 - defaultBottomPaddingValue
        case .device5_4inch where bookTappedCount <= 4:
            return 30.0 - defaultBottomPaddingValue // 기본 패딩 값
        case .device5_5inch where bookTappedCount <= 2:
            return 263.0 - defaultBottomPaddingValue
        case .device5_5inch where bookTappedCount <= 4:
            return 30.0 - defaultBottomPaddingValue // 기본 패딩 값
        case .device5_8inch where bookTappedCount <= 2:
            return 302.0 - defaultBottomPaddingValue
        case .device5_8inch where bookTappedCount <= 4:
            return 30.0 - defaultBottomPaddingValue // 기본 패딩 값
        case .device6_1inch where bookTappedCount <= 2:
            return 324.0 - defaultBottomPaddingValue
        case .device6_1inch where bookTappedCount <= 4:
            return 20.0 - defaultBottomPaddingValue
        case .device6_5inch where bookTappedCount <= 2:
            return 385.0 - defaultBottomPaddingValue
        case .device6_5inch where bookTappedCount <= 4:
            return 80.0 - defaultBottomPaddingValue
        case .device6_7inch where bookTappedCount <= 2:
            return 406.0 - defaultBottomPaddingValue
        case .device6_7inch where bookTappedCount <= 4:
            return 100.0 - defaultBottomPaddingValue
        default:
            return 30.0 - defaultBottomPaddingValue // 기본 패딩 값
        }
    }
    
    // MARK: - INTIALIZER
    
    init(scrollProxy: ScrollViewProxy) {
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        tabContent
            .onAppear {
                bookCategories = getCategory(readingBooks.get(of: .unfinished))
            }
            .onAppear {
                bookTappedCount = readingBooks.getFilteredReadingBooks(
                    .unfinished,
                    sort: homeViewData.selectedBookSort,
                    category: homeViewData.selectedCategory
                ).count
            }
            .onChange(of: homeViewData.selectedCategory) { _ in
                bookTappedCount = readingBooks.getFilteredReadingBooks(
                    .unfinished,
                    sort: homeViewData.selectedBookSort,
                    category: homeViewData.selectedCategory
                ).count
            }
    }
    
    // MARK: - FUNCTIONS
    
    func getDeviceSceenSize(_ device: Device) -> DeviceScreenSize {
        let device4_7inch: [Device] = [.iPhone8, .iPhoneSE2, .iPhoneSE3]
        let device5_4inch: [Device] = [.iPhone12Mini, .iPhone13Mini]
        let device5_5inch: [Device] = [.iPhone8Plus]
        let device5_8inch: [Device] = [.iPhoneX, .iPhoneXS, .iPhone11Pro]
        let device6_1inch: [Device] = [.iPhoneXR, .iPhone11, .iPhone12, .iPhone12Pro, .iPhone13, .iPhone13Pro, .iPhone14, .iPhone14Pro]
        let device6_5inch: [Device] = [.iPhoneXSMax, .iPhone11ProMax]
        let device6_7inch: [Device] = [.iPhone12ProMax, .iPhone13ProMax, .iPhone14Plus, .iPhone14ProMax]
        
        switch device {
        case _ where device4_7inch.contains(device):
            return .device4_7inch
        case _ where device5_4inch.contains(device):
            return .device5_4inch
        case _ where device5_5inch.contains(device):
            return .device5_5inch
        case _ where device5_8inch.contains(device):
            return .device5_8inch
        case _ where device6_1inch.contains(device):
            return .device6_1inch
        case _ where device6_5inch.contains(device):
            return .device6_5inch
        case _ where device6_7inch.contains(device):
            return .device6_7inch
        default:
            return .otherSize
        }
    }
    
    func getCategory(_ books: [CompleteBook]) -> [Category] {
        var categories: [Category] = []
        
        // 중복되지 않게 카테고리 항목 저장하기
        for book in books where !categories.contains(book.category) {
            categories.append(book.category)
        }
        // 카테고리 항목에 '기타'가 있다면
        if let index = categories.firstIndex(of: .etc) {
            categories.remove(at: index) // '기타' 항목 제거
            // 카테고리 이름을 오름차순(가, 나, 다)으로 정렬
            categories.sort {
                $0.name < $1.name
            }
            // '기타'를 제일 뒤로 보내기
            categories.append(.etc)
        } else {
            // 카테고리 이름을 오름차순(가, 나, 다)으로 정렬
            categories.sort {
                $0.name < $1.name
            }
        }
        // 카테고리의 첫 번째에 '전체' 항목 추가
        categories.insert(.all, at: 0)
        return categories
    }
}

// MARK: - EXTENSIONS

extension HomeReadingBookTabView {
    var tabContent: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            tabTitle
            
            Section {
                booksContent
            } header: {
                categoryButtonGroup(scrollProxy: scrollProxy)
            }
        }
    }
    
    var tabTitle: some View {
        HStack {
            headlineText
            
            bookSortMenu
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
    
    var bookSortMenu: some View {
        Menu {
            Section {
                sortButtonGroup
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
        ForEach(BookSortCriteria.allCases) { sort in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            homeViewData.selectedBookSort = sort
                        }
                        haptic.impact(.rigid)
                    }
                }
            } label: {
                Text(sort.name)
                if homeViewData.selectedBookSort == sort {
                    Text("적용됨")
                }
            }
        }
    }
    
    var booksContent: some View {
        Group {
            if filteredBooks.isEmpty {
                noBooksLabel
            } else {
                bookButtonGroup
            }
        }
    }
    
    var noBooksLabel: some View {
        VStack(spacing: 5) {
            Text("읽고 있는 도서가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("도서를 추가하십시오.")
                .foregroundColor(.secondary)
        }
        .padding(.top, 50)
    }
    
    var bookButtonGroup: some View {
        Group {
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(filteredBooks) { book in
                    HomeReadingBookButton(book)
                }
            }
            .padding([.leading, .top, .trailing])
            .padding(.bottom, defaultBottomPaddingValue)
            .padding(.bottom, dynamicBottomPaddingValue)
        }
    }
    
    func categoryButtonGroup(scrollProxy proxy: ScrollViewProxy) -> some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(bookCategories, id: \.self) { category in
                        HomeCategoryButton(
                            category,
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

#Preview {
    ScrollViewReader { scrollProxy in
        HomeReadingBookTabView(scrollProxy: scrollProxy)
            .environmentObject(HomeViewData())
            .environmentObject(RealmManager())
    }
}
