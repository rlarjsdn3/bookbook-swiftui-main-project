//
//  SearchLazyGridView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct SearchLazyGridView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var listTypeSelected: ListType
    
    var bookListItems: [BookList.Item] {
        switch listTypeSelected {
        case .bestSeller:
            return bookViewModel.bestSeller
        case .itemNewAll:
            return bookViewModel.itemNewAll
        case .itemNewSpecial:
            return bookViewModel.itemNewSpecial
        case .blogBest:
            return bookViewModel.blogBest
        }
    }
    
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookViewModel: AladinAPIManager
    @State private var showSearchDetailView = false
    @State private var tapSearchIsbn13 = ""
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color("Background")
            
            if !bookListItems.isEmpty {
                ScrollViewReader { proxy in
                    scrollLazyGridCells(scrollProxy: proxy)
                }
            } else {
                VStack {
                    noResultsLabel
                    
                    refreshButton
                }
                .frame(maxHeight: .infinity)
            }
        }
    }
}

// MARK: - EXTENSIONS

extension SearchLazyGridView {
    var lazyGridCells: some View {
        LazyVGrid(columns: columns, spacing: 25) {
            ForEach(bookListItems, id: \.self) { item in
                ListTypeCellView(bookItem: item)
                    .sheet(isPresented: $showSearchDetailView) {
                        SearchSheetView(bookDetailsISBN13: $tapSearchIsbn13)
                    }
                    .onTapGesture {
                        showSearchDetailView = true
                        tapSearchIsbn13 = item.isbn13
                    }
            }
        }
        // 하단 사용자화 탭 뷰가 기본 탭 뷰와 높이가 상이하기 때문에 위/아래 간격을 달리함
        .padding(.top, 20)
        .padding(.bottom, 40)
        .padding(.horizontal, 10)
        .id("Scroll_To_Top")
    }
    
    var noResultsLabel: some View {
        VStack(spacing: 5) {
            Image(systemName: "xmark.circle")
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding(.vertical, 16)
            
            Text("도서 정보 불러오기 실패")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("잠시 후 다시 시도하십시오.")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(height: 110)
    }
    
    var refreshButton: some View {
        Button("다시 불러오기") {
            for type in ListType.allCases {
                bookViewModel.requestBookListAPI(type: type)
            }
            Haptics.shared.play(.rigid)
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
}

extension SearchLazyGridView {
    @ViewBuilder
    func scrollLazyGridCells(scrollProxy proxy: ScrollViewProxy) -> some View {
        ScrollView(showsIndicators: false) {
            lazyGridCells
        }
        // 도서 리스트 타입이 변경될 때마다 리스트의 스크롤을 맨 위로 올림
        .onChange(of: listTypeSelected) { _ in
            withAnimation {
                proxy.scrollTo("Scroll_To_Top", anchor: .top)
            }
        }
    }
}

// MARK: - PREVIEW

struct SearchLazyGridView_Previews: PreviewProvider {
    static var previews: some View {
        SearchLazyGridView(listTypeSelected: .constant(.bestSeller))
            .environmentObject(AladinAPIManager())
    }
}
