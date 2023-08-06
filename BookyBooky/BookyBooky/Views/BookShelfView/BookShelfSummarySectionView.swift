//
//  BookShelfSummaryTabView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/17/23.
//

import SwiftUI
import RealmSwift

struct BookShelfSummarySectionView: View {
    
    // MARK: - INNER ENUM
    
    enum SummaryTabItem: CaseIterable {
        case compBookCount
        case favBookCount
        case sentenceCount
        
        var name: String {
            switch self {
            case .compBookCount:
                return "읽은 도서 수"
            case .favBookCount:
                return "찜한 도서 수"
            case .sentenceCount:
                return "수집 문장 수"
            }
        }
        
        var systemImage: String {
            switch self {
            case .compBookCount:
                return "book"
            case .favBookCount:
                return "heart.fill"
            case .sentenceCount:
                return "bookmark.fill"
            }
        }
        
        var themeColor: AnyGradient {
            switch self {
            case .compBookCount:
                return Color.blue.gradient
            case .favBookCount:
                return Color.pink.gradient
            case .sentenceCount:
                return Color.green.gradient
            }
        }
    }
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(CompleteBook.self) var readingBooks
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    // MARK: - COMPUTED PROPERTIES
    
    var numOfCompleteBook: Int {
        return readingBooks.filter { $0.isComplete }.count
    }
    
    var numOfFavoriteBook: Int {
        return favoriteBooks.count
    }
    
    var numOfCollectedSentence: Int {
        var count: Int = 0
        
        for book in readingBooks {
            count += book.sentences.count
        }
        return count
    }
    
    // MARK: - BODY
    
    var body: some View {
        summarySectionArea
    }
}

// MARK: - EXTENSIONS

extension BookShelfSummarySectionView {
    var summarySectionArea: some View {
        HStack {
            ForEach(SummaryTabItem.allCases, id: \.self) { item in
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
    
    func summaryImage(_ item: SummaryTabItem) -> some View {
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
    
    func summaryLabel(_ item: SummaryTabItem) -> some View {
        Text(item.name)
            .fontWeight(.bold)
    }
    
    func summaryCount(_ item: SummaryTabItem) -> some View {
        Group {
            switch item {
            case .compBookCount:
                return Text("\(numOfCompleteBook)")
            case .favBookCount:
                return Text("\(numOfFavoriteBook)")
            case .sentenceCount:
                return Text("\(numOfCollectedSentence)")
            }
        }
        .font(.title2)
    }
}

// MARK: - PREVIEW

struct BookShelfSummarySectionView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfSummarySectionView()
    }
}
