//
//  BookShelfSentenceListView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/03.
//

import SwiftUI
import RealmSwift

struct BookShelfSentenceListView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(CompleteBook.self) var readingBooks
    
    @Binding var searchQuery: String
    @Binding var selectedSort: BookSortCriteria
    
    // MARK: - COMPUTED PROPERTIES
    
    var filteredCompBooks: [CompleteBook] {
        readingBooks.getFilteredReadingBooks(
            .all,
            searchQuery: searchQuery,
            bookSortType: selectedSort
        )
    }

    // MARK: - BODY
    
    var body: some View {
        Group {
            if filteredCompBooks.isEmpty {
                noResultsLabel
            } else {
                sentenceButtonGroup
            }
        }
    }
}

// MARK: - EXTENSIONS

extension BookShelfSentenceListView {
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
                ForEach(filteredCompBooks) { readingBook in
                    if !readingBook.collectSentences.isEmpty {
                        Section {
                            VStack {
                                ForEach(readingBook.collectSentences.sorted { $0.page < $1.page }, id: \.self) { collect in
                                    SentenceButton(readingBook, collectSentence: collect)
                                }
                            }
                        } header: {
                            Text(readingBook.title)
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
        BookShelfSentenceListView(
            searchQuery: .constant(""),
            selectedSort: .constant(.titleAscendingOrder)
        )
    }
}
