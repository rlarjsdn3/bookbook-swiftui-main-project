//
//  BookShelfScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI
import RealmSwift

struct BookShelfScrollView: View {
    
    // MARK: - PROPERTIES
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @Binding var scrollYOffset: CGFloat
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    @ObservedResults(ReadingBook.self) var readingBooks
    
    @State private var isPresentingFavoriteBookListView = false
    @State private var isPresentingCompleteBookListView = false
    
    @State private var tapISBN13 = ""
    @State private var showFavoriteBookInfo = false
    @State private var startOffset: CGFloat = 0.0
    
    // MARK: - BODY
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                bookShelfSummary
                
                favoriteBookSection
                
                // 읽은 도서 섹션 (미완성)
                Section {
                    let readingBook = realmManager.getReadingBooks(isComplete: true)
                    
                    if readingBook.isEmpty {
                        VStack(spacing: 5) {
                            Text("읽은 도서가 없음")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Text("독서를 시작해보세요.")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 30)
                        .padding(.bottom, 100) // 임시
                    } else {
                        LazyVGrid(columns: columns) {
                            
                            // 모두 읽은 도서를 삭제 할때, 에러가 나는 이유는 삭제된 오브젝트에 접근해서 리스트를 만드렫고 했기 때문!
                            // 이걸 수정하기 위해, 오브젝트가 변경될 때마다 UI를 새로 그리는 readingBooks 프로퍼티 래퍼 변수에다가
                            // 별도 필터링을 해주어 리스트로 출력하게 해야함! -> 
                            
                            // 수정
                            ForEach(readingBooks.filter({ $0.isComplete }), id: \.self) { book in
                                ReadingBookCellButton(readingBook: book, buttonType: .shelf)
                            }
                        }
                        .padding(.bottom, 40)
                    }
                } header: {
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
                        .disabled(readingBooks.isEmpty)
                    }
//                    .padding(.top, -8)
                    .padding(.vertical, 10)
                    .padding(.bottom, 5)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .opacity(!favoriteBooks.isEmpty ? scrollYOffset > 480.0 ? 1 : 0 : scrollYOffset > 290.0 ? 1 : 0)
                    }
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
            .sheet(isPresented: $isPresentingFavoriteBookListView) {
                FavoriteBooksView(listType: .favorite)
            }
            .sheet(isPresented: $isPresentingCompleteBookListView) {
                FavoriteBooksView(listType: .complete)
            }
        }
    }
}

// MARK: - EXTENSIONS

extension BookShelfScrollView {
    func asyncImage(url: String) -> some View {
        AsyncImage(url: URL(string: url),
                   transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 200)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 15,
                            style: .continuous
                        )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: -5, y: 5)
            case .failure(_), .empty:
                loadingImage
            @unknown default:
                loadingImage
            }
        }
    }
    
    var loadingImage: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.gray.opacity(0.2))
            .frame(width: 150, height: 200)
            .shimmering()
    }
}

extension BookShelfScrollView {
    var bookShelfSummary: some View {
        HStack {
            ForEach(BookShelfSummaryItems.allCases, id: \.self) { item in
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
    }
    
    func summaryImage(_ item: BookShelfSummaryItems) -> some View {
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
    
    func summaryLabel(_ item: BookShelfSummaryItems) -> some View {
        Text(item.name)
            .fontWeight(.bold)
    }
    
    func summaryCount(_ item: BookShelfSummaryItems) -> some View {
        switch item {
        case .completeBooksCount:
            return Text("\(readingBooks.filter { $0.isComplete }.count)").font(.title2)
        case .favoriteBooksCount:
            return Text("\(favoriteBooks.count)").font(.title2)
        case .collectSentencesCount:
            return Text("0").font(.title2)
        }
    }
    
    var favoriteBookSection: some View {
        Section {
            if !favoriteBooks.isEmpty {
                scrollFavoriteBooks
            } else {
                noFavoriteBooksLabel
            }
        } header: {
            favoriteBooksHeaderLabel
        }
    }
    
    var scrollFavoriteBooks: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                // 최근에 추가된 상위 10게 힝목만 보여줌
                ForEach(favoriteBooks.reversed().prefix(min(10, favoriteBooks.count))) { favoriteBook in
                    FavoriteBookCellView(favoriteBook: favoriteBook, viewType: .sheet)
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
    
    var favoriteBooksHeaderLabel: some View {
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
//        .padding(.top, -3)
        .padding(.vertical, 10)
        .padding(.bottom, 5)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .overlay(alignment: .bottom) {
            Divider()
                .opacity(scrollYOffset > 150.0 ? 1 : 0)
        }
    }
}

// MARK: - PREVIEW

struct BookShelfScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfScrollView(scrollYOffset: .constant(0.0))
            .environmentObject(RealmManager())
    }
}
