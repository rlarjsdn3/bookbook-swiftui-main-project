//
//  SearchLazyGridView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI
import AlertToast

struct BookListScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookListViewData: BookListViewData
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    // MARK: - PROPERTIES
    
    let haptic = HapticManager()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - BODY
    
    var body: some View {
        scrollContent
    }
    
    // MARK: - FUNCTIONS
    
    func getBookList(_ tab: BookListType) -> [SimpleBookInfo.Item] {
        switch tab {
        case .bestSeller:
            return bookListViewData.bestSeller
        case .itemNewAll:
            return bookListViewData.itemNewAll
        case .itemNewSpecial:
            return bookListViewData.itemNewSpecial
        case .blogBest:
            return bookListViewData.blogBest
        }
    }
}

// MARK: - EXTENSIONS

extension BookListScrollView {
    var scrollContent: some View {
        ScrollViewReader { proxy in
            TrackableVerticalScrollView(yOffset: $bookListViewData.scrollYOffset) {
                bookButtonGroup
                    .id("Scroll_To_Top")
            }
            .onChange(of: bookListViewData.selectedListTab) { _ in
                withAnimation {
                    proxy.scrollTo("Scroll_To_Top", anchor: .top)
                }
            }
            .scrollIndicators(.hidden)
        }
        .background(Color.customBackground)
    }
    
    var bookButtonGroup: some View {
        LazyVGrid(columns: columns, spacing: 25) {
            let bookList = getBookList(bookListViewData.selectedListTab)
            
            ForEach(bookList, id: \.self) { book in
                BookListButton(book)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal)
        .padding(.bottom, 40)
    }
}

// MARK: - PREVIEW

struct BookListScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BookListScrollView()
            .environmentObject(BookListViewData())
            .environmentObject(AladinAPIManager())
    }
}
