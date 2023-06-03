//
//  BookShelfSentenceListView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/03.
//

import SwiftUI
import RealmSwift

struct BookShelfSentenceListView: View {
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    @Binding var searchQuery: String
    @Binding var selectedSortType: BookSortCriteriaType
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ForEach(readingBooks) { readingBook in
                    if !readingBook.collectSentences.isEmpty {
                        Section {
                            ForEach(readingBook.collectSentences, id: \.self) { collect in
                                SentenceCellButton(readingBook, collectSentence: collect)
                            }
                        } header: {
                            Text(readingBook.title)
                                .font(.title3.weight(.bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                                .truncationMode(.middle)
                                .padding([.horizontal, .top])
                                .padding(.bottom, 7)
                                .background(Color.white)
                        }
                    }
                }
            }
        }
    }
}

struct BookShelfSentenceListView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfSentenceListView(
            searchQuery: .constant(""),
            selectedSortType: .constant(.titleOrder)
        )
    }
}
