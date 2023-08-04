//
//  ReadingBookCollectSentencesView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift
import Shimmer

struct CompleteBookSentenceView: View {
    
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var completeBook: CompleteBook
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook) {
        self.completeBook = completeBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        scrollContent
    }
}

// MARK: - EXTENSIONS

extension CompleteBookSentenceView {
    var scrollContent: some View {
        Group {
            if completeBook.sentences.isEmpty {
                noSentencesLabel
            } else {
                ScrollView {
                    let sentences = completeBook.sentences.sorted(by: { $0.page < $1.page })
                    
                    ForEach(sentences, id: \.self) { sentence in
                        SentenceCellButton(
                            completeBook,
                            collectSentence: sentence
                        )
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    var noSentencesLabel: some View {
        VStack(spacing: 5) {
            Text("수집한 문장이 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("문장을 수집해보세요.")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 50)
    }
}

// MARK: - PREVIEW

#Preview {
    CompleteBookSentenceView(CompleteBook.preview)
}
