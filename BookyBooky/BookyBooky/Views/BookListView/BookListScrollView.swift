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
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - COMPUTED PROPERTIES
    
    var bookList: [briefBookItem.Item] {
        switch bookListViewData.selectedListTab {
        case .bestSeller:
            return aladinAPIManager.bestSeller
        case .itemNewAll:
            return aladinAPIManager.itemNewAll
        case .itemNewSpecial:
            return aladinAPIManager.itemNewSpecial
        case .blogBest:
            return aladinAPIManager.blogBest
        }
    }
    
    
    // MARK: - BODY
    
    var body: some View {
        bookScrollContent
    }
}

// MARK: - EXTENSIONS

extension BookListScrollView {
    var bookScrollContent: some View {
        Group {
            if bookList.isEmpty {
                errorLabel
            } else {
                bookScroll
            }
        }
        .background(Color(.background))
    }
    
    var bookScroll: some View {
        ScrollViewReader { proxy in
            TrackableVerticalScrollView(yOffset: $bookListViewData.scrollYOffset) {
                bookButtonGroup
                    .id("Scroll_To_Top")
            }
            .onChange(of: bookListViewData.selectedListTab, initial: true) {
                withAnimation {
                    proxy.scrollTo("Scroll_To_Top", anchor: .top)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    var bookButtonGroup: some View {
        LazyVGrid(columns: columns, spacing: 25) {
            ForEach(bookList, id: \.self) { item in
                BookListBookButton(item)
            }
        }
        .safeAreaPadding(.top, 20)
        .safeAreaPadding(.horizontal)
        .safeAreaPadding(.bottom, 40)
    }
    
    var errorLabel: some View {
        VStack {
            ErrorLabel
            
            refreshButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var ErrorLabel: some View {
        VStack(spacing: 5) {
            Text("도서 정보 불러오기 실패")
                .font(.title2)
                .fontWeight(.bold)

            Text("잠시 후 다시 시도하십시오.")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding(.bottom, 0)
    }
    
    var refreshButton: some View {
        Button("다시 불러오기") {
            for type in BookListTab.allCases {
                aladinAPIManager.requestBookListAPI(of: type)
            }
            HapticManager.shared.impact(.rigid)
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
}

// MARK: - PREVIEW

struct SearchListScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BookListScrollView()
            .environmentObject(BookListViewData())
            .environmentObject(AladinAPIManager())
    }
}
