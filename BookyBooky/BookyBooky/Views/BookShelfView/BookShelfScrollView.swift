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
    
    @Binding var scrollYOffset: CGFloat
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    @State private var isPresentingFavoriteBooksView = false
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
                    ForEach(1..<100) { index in
                        Text("UI 미완성")
                            .font(.title3)
                            .padding()
                            .background(.gray.opacity(0.3))
                            .cornerRadius(15)
                            .shimmering()
                            .padding(.vertical, 25)
                    }
                } header: {
                    HStack {
                        Text("읽은 도서")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding([.horizontal, .bottom], 5)
                        
                        Spacer()
                    }
                    .padding(.vertical, 6)
                    .padding([.horizontal, .bottom], 5)
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
            .sheet(isPresented: $isPresentingFavoriteBooksView) {
                FavoriteBooksView()
            }
        }
    }
    
    // 이제 사용 안하는 함수 -> HomeView로 이동
}

// MARK: - EXTENSIONS

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
            return Text("0").font(.title2)
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
        Text("찜한 도서가 없음")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.secondary)
            .padding(.vertical, 30)
    }
    
    var favoriteBooksHeaderLabel: some View {
        HStack {
            Text("찜한 도서")
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                isPresentingFavoriteBooksView = true
            } label: {
                Text("더 보기")
            }
            .disabled(favoriteBooks.isEmpty)

        }
        .padding(.top, -7)
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
    }
}
