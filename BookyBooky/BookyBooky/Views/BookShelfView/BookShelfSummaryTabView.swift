//
//  BookShelfSummaryTabView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/17/23.
//

import SwiftUI
import RealmSwift

struct BookShelfSummaryTabView: View {
    
    // MARK: - INNER ENUM
    
    enum BookShelfSummary: CaseIterable {
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
        
        var themeColor: AnyGradient {
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
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(CompleteBook.self) var readingBooks
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    // MARK: - COMPUTED PROPERTIES
    
    var completeBookCount: Int {
        return readingBooks.filter { $0.isComplete }.count
    }
    
    var favoriteBookCount: Int {
        return favoriteBooks.count
    }
    
    var collectedSentenceCount: Int {
        var count: Int = 0
        
        for readingBook in readingBooks {
            count += readingBook.collectSentences.count
        }
        return count
    }
    
    var body: some View {
        summaryTab
    }
}

extension BookShelfSummaryTabView {
    var summaryTab: some View {
        HStack {
            ForEach(BookShelfSummary.allCases, id: \.self) { item in
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
    
    func summaryImage(_ item: BookShelfSummary) -> some View {
        Image(systemName: item.systemImage)
            .font(.largeTitle)
            .foregroundColor(.white)
            .background {
                Circle()
                    .fill(item.themeColor)
                    .frame(width: 70, height: 70)
            }
            .frame(width: 80, height: 80)
    }
    
    func summaryLabel(_ item: BookShelfSummary) -> some View {
        Text(item.name)
            .fontWeight(.bold)
    }
    
    func summaryCount(_ item: BookShelfSummary) -> some View {
        Group {
            switch item {
            case .completeBooksCount:
                return Text("\(completeBookCount)")
            case .favoriteBooksCount:
                return Text("\(favoriteBookCount)")
            case .collectedSentenceCount:
                return Text("\(collectedSentenceCount)")
            }
        }
        .font(.title2)
    }
}

#Preview {
    BookShelfSummaryTabView()
}
