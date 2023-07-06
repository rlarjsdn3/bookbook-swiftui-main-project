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
    
    var filteredCompBooks: [CompleteBook] {
        completeBooks.getFilteredReadingBooks(
            .all,
            searchQuery: bookShelfSentenceListViewData.searchQuery,
            bookSortType: bookShelfSentenceListViewData.selectedSort
        )
    }

    // MARK: - BODY
    
    var body: some View {
        sentenceScrollContent
    }
    
    // MARK: - FUNCTIONS
    
    func hasCollectedSentences() -> Bool {
        let compBooks = filteredCompBooks
        for compBook in compBooks where !compBook.isSentencesEmpty {
            return true
        }
        return false
    }
}

// MARK: - EXTENSIONS

extension BookShelfSentenceScrollView {
    var sentenceScrollContent: some View {
        Group {
            if hasCollectedSentences() {
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
                ForEach(filteredCompBooks) { compBook in
                    if !compBook.sentences.isEmpty {
                        Section {
                            VStack {
                                let sortedSentences = compBook.sentences.sorted(
                                    by: { $0.page < $1.page }
                                )
                                ForEach(sortedSentences, id: \.self) { collect in
                                    SentenceCellButton(compBook, collectSentence: collect)
                                }
                            }
                        } header: {
                            Text(compBook.title)
                                .font(.title3.weight(.bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                                .truncationMode(.middle)
                                .padding([.horizontal, .top, .bottom])
                                .background(Color.white)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - PREVIEW

struct BookShelfSentenceListView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfSentenceScrollView()
            .environmentObject(BookShelfSentenceListViewData())
    }
}
