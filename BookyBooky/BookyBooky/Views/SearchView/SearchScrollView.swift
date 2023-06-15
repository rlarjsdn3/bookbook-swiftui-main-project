//
//  SearchLazyGridView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI
import AlertToast

struct SearchScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @State private var startOffset: CGFloat = 0.0
    
    // MARK: - PROPERTIES
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var scrollYOffset: CGFloat
    @Binding var selectedListType: BookListTabType
    
    // MARK: - INTALIZER
    
    init(_ scrollYOffset: Binding<CGFloat>, selectedListType: Binding<BookListTabType>) {
        self._scrollYOffset = scrollYOffset
        self._selectedListType = selectedListType
    }
    
    // MARK: - COMPUTED PROPERTIES
    
    var listOfBooksAccordingToSelectedType: [briefBookInfo.Item] {
        switch selectedListType {
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
        ZStack {
            Color(.background)
            
            if listOfBooksAccordingToSelectedType.isEmpty {
                networkErrorLabel
            } else {
                scrollLazyGridCells
            }
        }
    }
}

// MARK: - EXTENSIONS

extension SearchScrollView {
    var scrollLazyGridCells: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(showsIndicators: false) {
                searchCellButtons
            }
            // 도서 리스트 타입이 변경될 때마다 리스트의 스크롤을 맨 위로 올림
            .onChange(of: selectedListType) { _ in
                withAnimation {
                    scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                }
            }
        }
    }
    
    var searchCellButtons: some View {
        LazyVGrid(columns: columns, spacing: 25) {
            ForEach(listOfBooksAccordingToSelectedType, id: \.self) { item in
                SearchListBookButton(item)
            }

        }
        .overlay(alignment: .top) {
            GeometryReader { proxy -> Color in
                DispatchQueue.main.async {
                    let offset = proxy.frame(in: .global).minY
                    if startOffset == 0 {
                        self.startOffset = offset
                    }
                    withAnimation(.easeInOut(duration: 0.2)) {
                        scrollYOffset = startOffset - offset
                    }
                    print(scrollYOffset)
                }
                return Color.clear
            }
            .frame(width: 0, height: 0)
        }
        // 하단 사용자화 탭 뷰가 기본 탭 뷰와 높이가 상이하기 때문에 위/아래 간격을 달리함
        .padding(.top, 20)
        .padding(.bottom, 40)
        .padding(.horizontal, 10)
        .id("Scroll_To_Top")
    }
    
    var networkErrorLabel: some View {
        VStack {
            noListOfBooksLabel
            
            refreshButton
        }
    }
    
    var noListOfBooksLabel: some View {
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
            for type in BookListTabType.allCases {
                aladinAPIManager.requestBookListAPI(of: type)
            }
            HapticManager.shared.impact(.rigid)
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
}

// MARK: - PREVIEW

struct SearchLazyGridView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScrollView(.constant(0.0), selectedListType: .constant(.bestSeller))
            .environmentObject(AladinAPIManager())
    }
}
