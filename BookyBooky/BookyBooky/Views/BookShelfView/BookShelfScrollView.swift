//
//  BookShelfScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI
import RealmSwift

enum BookShelfSummaryType: CaseIterable {
    case completeBooksCount
    case favoriteBooksCount
    case collectedSentenceCount
    
    var name: String {
        switch self {
        case .completeBooksCount:
            return "읽은 도서 수"
        case .favoriteBooksCount:
            return "찜한 도서 수"
        case .collectedSentenceCount:
            return "수집 문장 수"
        }
    }
    
    var systemImage: String {
        switch self {
        case .completeBooksCount:
            return "book"
        case .favoriteBooksCount:
            return "heart.fill"
        case .collectedSentenceCount:
            return "bookmark.fill"
        }
    }
    
    var color: AnyGradient {
        switch self {
        case .completeBooksCount:
            return Color.blue.gradient
        case .favoriteBooksCount:
            return Color.pink.gradient
        case .collectedSentenceCount:
            return Color.green.gradient
        }
    }
}

struct BookShelfScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    @ObservedResults(ReadingBook.self) var readingBooks
    
    @State private var startOffset: CGFloat = 0.0
    
    @State private var isPresentingFavoriteBookListView = false
    @State private var isPresentingCompleteBookListView = false
    
    // MARK: - COMPUTED PROPERTIES
    
    var completeBookCount: Int {
        return readingBooks.filter { $0.isComplete }.count
    }
    
    var favoriteBookCount: Int {
        return favoriteBooks.count
    }
    
    var collectedSentenceCount: Int {
        return 0 // 코드 미완성
    }
    
    // MARK: - PROPERTIES
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var scrollYOffset: Double
    
    // MARK: - INTIALIZER
    
    init(_ scrollOffset: Binding<Double>) {
        self._scrollYOffset = scrollOffset
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookShelfScroll
    }
}

// MARK: - EXTENSIONS

extension BookShelfScrollView {
    var bookShelfScroll: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                topSummaryTab
                
                favoriteBookSection
                
                completeBookSection
            }
            // 컨테이너의 상단 Y축의 위치 좌표값을 반환
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
            .sheet(isPresented: $isPresentingFavoriteBookListView) {
                BookShelfListView(viewType: .favorite)
            }
            .sheet(isPresented: $isPresentingCompleteBookListView) {
                BookShelfListView(viewType: .complete)
            }
        }
    }
}

extension BookShelfScrollView {
    var topSummaryTab: some View {
        HStack {
            ForEach(BookShelfSummaryType.allCases, id: \.self) { item in
                Spacer()
                
                VStack(spacing: 5) {
                    summaryImage(item)
                    
                    summaryLabel(item)
                    
                    summaryCount(item)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
    }
    
    func summaryImage(_ item: BookShelfSummaryType) -> some View {
        Image(systemName: item.systemImage)
            .font(.largeTitle)
            .foregroundColor(.white)
            .background {
                Circle()
                    .fill(item.color)
                    .frame(width: 70, height: 70)
            }
            .frame(width: 80, height: 80)
    }
    
    func summaryLabel(_ item: BookShelfSummaryType) -> some View {
        Text(item.name)
            .fontWeight(.bold)
    }
    
    func summaryCount(_ item: BookShelfSummaryType) -> some View {
        switch item {
        case .completeBooksCount:
            return Text("\(completeBookCount)").font(.title2)
        case .favoriteBooksCount:
            return Text("\(favoriteBookCount)").font(.title2)
        case .collectedSentenceCount:
            return Text("\(collectedSentenceCount)").font(.title2)
        }
    }
}

extension BookShelfScrollView {
    var favoriteBookSection: some View {
        Section {
            if favoriteBooks.isEmpty {
                noFavoriteBooksLabel
            } else {
                scrollFavoriteBooks
            }
        } header: {
            favoriteBooksHeader
        }
    }
    
    var scrollFavoriteBooks: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                let recent10FavoriteBooks = favoriteBooks.reversed().prefix(min(10, favoriteBooks.count))
                
                ForEach(recent10FavoriteBooks) { favoriteBook in
                    FavoriteBookCellButton(favoriteBook, viewType: .sheet)
                        .padding(.vertical, 10)
                }
            }
        }
        .padding(.horizontal, 3)
    }
    
    var noFavoriteBooksLabel: some View {
        VStack(spacing: 5) {
            Text("찜한 도서가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("도서를 찜해보세요.")
                .foregroundColor(.secondary)
        }
        .padding(.top, 30)
        .padding(.bottom, 40)
    }
    
    var favoriteBooksHeader: some View {
        HStack {
            Text("찜한 도서")
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                isPresentingFavoriteBookListView = true
            } label: {
                Text("더 보기")
            }
            .disabled(favoriteBooks.isEmpty)

        }
        .padding(.vertical, 10)
        .padding(.bottom, 5)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(.white)
        .overlay(alignment: .bottom) {
            Divider()
                .opacity(scrollYOffset > 150.0 ? 1 : 0)
        }
    }
}

extension BookShelfScrollView {
    var completeBookSection: some View {
        Group {
            let completeBooks = readingBooks.get(.complete)
            
            Section {
                if completeBooks.isEmpty {
                    noFavoriteBooksLabel
                } else {
                    scrollCompleteBooks(completeBooks)
                }
            } header: {
                completeBooksHeader(completeBooks)
            }
        }
    }
    
    func scrollCompleteBooks(_ completeBooks: [ReadingBook]) -> some View {
        LazyVGrid(columns: columns) {
            ForEach(completeBooks, id: \.self) { book in
                ReadingBookCellButton(book, buttonType: .shelf)
                    .padding(.top, 10)
            }
        }
        .padding(.bottom, 40)
    }
    
    var noCompleteBooksLabel: some View {
        VStack(spacing: 5) {
            Text("읽은 도서가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("독서를 시작해보세요.")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 30)
        .padding(.bottom, 100) // 임시
    }
    
    func completeBooksHeader(_ completeBooks: [ReadingBook]) -> some View {
        HStack {
            Text("읽은 도서")
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                isPresentingCompleteBookListView = true
            } label: {
                Text("더 보기")
            }
            .disabled(completeBooks.isEmpty)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .padding(.bottom, 5)
        .padding(.horizontal)
        .background(.white)
        
        .overlay(alignment: .bottom) {
            Divider()
                .opacity(!favoriteBooks.isEmpty ? scrollYOffset > 480.0 ? 1 : 0 : scrollYOffset > 290.0 ? 1 : 0)
        }
    }
}

// MARK: - PREVIEW

struct BookShelfScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfScrollView(.constant(0.0))
            .environmentObject(RealmManager())
    }
}
