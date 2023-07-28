//
//  HomeMainReadingBookView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/17.
//

import SwiftUI
import RealmSwift
import DeviceKit

enum DeviceScreenSize {
    case device4_7inch
    case device5_4inch
    case device5_5inch
    case device5_8inch
    case device6_1inch
    case device6_5inch
    case device6_7inch
    case otherSize
}

struct HomeCompleteBookTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var homeViewData: HomeViewData
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(CompleteBook.self) var compBooks
    
    @Namespace var namespace
    
    @State private var filteredCompleteBooks: [CompleteBook] = []
    @State private var selectedTabBookCount = 0
    @State private var bookCategories: [Category] = []
    
    // MARK: - PROPERTIES
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let scrollProxy: ScrollViewProxy
    var defaultBottomPaddingValue: CGFloat = 30.0
    
    // MARK: - COMPUTED PROPERTIES
    
    var dynamicBottomPaddingValue: CGFloat {
        let device = Device.current.realDevice
        
        switch getDeviceSceenSize(device) {
        case .device4_7inch where selectedTabBookCount <= 2:
            return 192.0 - defaultBottomPaddingValue
        case .device4_7inch where selectedTabBookCount <= 4:
            return 30.0 - defaultBottomPaddingValue // 기본 패딩 값
        case .device5_4inch where selectedTabBookCount <= 2:
            return 295.0 - defaultBottomPaddingValue
        case .device5_4inch where selectedTabBookCount <= 4:
            return 30.0 - defaultBottomPaddingValue // 기본 패딩 값
        case .device5_5inch where selectedTabBookCount <= 2:
            return 263.0 - defaultBottomPaddingValue
        case .device5_5inch where selectedTabBookCount <= 4:
            return 30.0 - defaultBottomPaddingValue // 기본 패딩 값
        case .device5_8inch where selectedTabBookCount <= 2:
            return 302.0 - defaultBottomPaddingValue
        case .device5_8inch where selectedTabBookCount <= 4:
            return 30.0 - defaultBottomPaddingValue // 기본 패딩 값
        case .device6_1inch where selectedTabBookCount <= 2:
            return 324.0 - defaultBottomPaddingValue
        case .device6_1inch where selectedTabBookCount <= 4:
            return 20.0 - defaultBottomPaddingValue
        case .device6_5inch where selectedTabBookCount <= 2:
            return 385.0 - defaultBottomPaddingValue
        case .device6_5inch where selectedTabBookCount <= 4:
            return 80.0 - defaultBottomPaddingValue
        case .device6_7inch where selectedTabBookCount <= 2:
            return 406.0 - defaultBottomPaddingValue
        case .device6_7inch where selectedTabBookCount <= 4:
            return 100.0 - defaultBottomPaddingValue
        default:
            return 30.0 - defaultBottomPaddingValue // 기본 패딩 값
        }
    }
    
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
    
    // MARK: - INTIALIZER
    
    init(scrollProxy: ScrollViewProxy) {
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        compBooksTab
            .onAppear {
                bookCategories = compBooks.get(.unfinished).getReadingBookCategoryType()
            }
            .onAppear {
                selectedTabBookCount = compBooks.getFilteredReadingBooks(
                    .unfinished,
                    sort: homeViewData.selectedBookSort,
                    category: homeViewData.selectedCategory
                ).count
            }
            .onChange(of: homeViewData.selectedCategory) { _ in
                selectedTabBookCount = compBooks.getFilteredReadingBooks(
                    .unfinished,
                    sort: homeViewData.selectedBookSort,
                    category: homeViewData.selectedCategory
                ).count
            }
            .onAppear {
                filteredCompleteBooks = compBooks.getFilteredReadingBooks(
                    .unfinished,
                    sort: homeViewData.selectedBookSort,
                    category: homeViewData.selectedCategory
                )
            }
            .onChange(of: homeViewData.selectedBookSort) { _ in
                filteredCompleteBooks = compBooks.getFilteredReadingBooks(
                    .unfinished,
                    sort: homeViewData.selectedBookSort,
                    category: homeViewData.selectedCategory
                )
            }
            .onChange(of: homeViewData.selectedCategory) { _ in
                filteredCompleteBooks = compBooks.getFilteredReadingBooks(
                    .unfinished,
                    sort: homeViewData.selectedBookSort,
                    category: homeViewData.selectedCategory
                )
            }
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
        ForEach(BookSortCriteria.allCases) { sort in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            homeViewData.selectedBookSort = sort
                        }
                        HapticManager.shared.impact(.rigid)
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
            // 리팩토링
            
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(filteredCompleteBooks) { completeBook in
                    CompleteBookButton(completeBook, type: .home)
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

struct HomeReadingBookTabView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            HomeCompleteBookTabView(scrollProxy: scrollProxy)
                .environmentObject(HomeViewData())
                .environmentObject(RealmManager())
        }
    }
}
