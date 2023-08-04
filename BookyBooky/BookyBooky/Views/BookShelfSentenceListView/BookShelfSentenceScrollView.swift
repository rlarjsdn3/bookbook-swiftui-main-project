//
//  BookShelfSentenceListView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/03.
//

import SwiftUI
import RealmSwift

struct BookShelfSentenceScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var bookShelfSentenceListViewData: BookShelfSentenceListViewData
    
    @ObservedResults(CompleteBook.self) var completeBooks
    
    // MARK: - COMPUTED PROPERTIES
    
    var filteredCompleteBooks: [CompleteBook] {
        completeBooks.getFilteredReadingBooks(
            .all,
            searchQuery: bookShelfSentenceListViewData.searchQuery,
            bookSortType: bookShelfSentenceListViewData.selectedSort
        )
    }
    
    var isExistSentences: Bool {
        let completeBooks = filteredCompleteBooks
        for book in completeBooks where !book.isSentencesEmpty {
            return true
        }
        return false
    }

    // MARK: - BODY
    
    var body: some View {
        scrollContent
    }
}

// MARK: - EXTENSIONS

extension BookShelfSentenceScrollView {
    var scrollContent: some View {
        Group {
            if isExistSentences {
                sentenceButtonGroup
            } else {
                noResultsLabel
            }
        }
    }

    var noResultsLabel: some View {
        VStack(spacing: 5) {
            Spacer()
            
            Text("수집한 문장이 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("문장을 수집해보세요.")
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
    
    var sentenceButtonGroup: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(filteredCompleteBooks) { book in
                    if !book.isSentencesEmpty {
                        Section {
                            VStack {
                                // ...
                                let sortedSentences = book.sentences.sorted(
                                    by: { $0.page < $1.page }
                                )
                                // ...
                                ForEach(sortedSentences, id: \.self) { collect in
                                    SentenceCellButton(book, sentence: collect)
                                }
                            }
                        } header: {
                            bookTitle(book)
                        }
                    }
                }
            }
        }
    }
    
    func bookTitle(_ book: CompleteBook) -> some View {
        Text(book.title)
            .font(.title3.weight(.bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
            .truncationMode(.middle)
            .padding([.horizontal, .top, .bottom])
            .background(Color.white)
    }
}

// MARK: - PREVIEW

#Preview {
    BookShelfSentenceScrollView()
        .environmentObject(BookShelfSentenceListViewData())
}
