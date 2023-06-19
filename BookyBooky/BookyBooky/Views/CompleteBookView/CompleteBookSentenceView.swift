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
        if completeBook.collectSentences.isEmpty {
            noCollectSentenceLabel
        } else {
            ScrollView {
                ForEach(completeBook.collectSentences.sorted { $0.page < $1.page }, id: \.self) { collect in
                    SentenceCellButton(
                        completeBook,
                        collectSentence: collect
                    )
                }
            }
            .padding(.bottom, 40)
        }
    }
}

extension CompleteBookSentenceView {
    var noCollectSentenceLabel: some View {
        VStack(spacing: 5) {
            Text("수집한 문장이 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("문장을 수집해보세요.")
                .foregroundColor(.secondary)
        }
        .padding(.top, 50)
        .padding(.bottom, 40)
    }
}

struct ReadingBookCollectSentencesView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteBookSentenceView(CompleteBook.preview)
    }
}
