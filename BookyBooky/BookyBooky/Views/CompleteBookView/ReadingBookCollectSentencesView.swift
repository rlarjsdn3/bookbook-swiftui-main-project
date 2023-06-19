//
//  ReadingBookCollectSentencesView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift
import Shimmer

struct ReadingBookCollectSentencesView: View {
    
    @ObservedRealmObject var readingBook: CompleteBook
    
    var body: some View {
        if readingBook.collectSentences.isEmpty {
            noCollectSentenceLabel
        } else {
            ScrollView {
                ForEach(readingBook.collectSentences.sorted { $0.page < $1.page }, id: \.self) { collect in
                    SentenceButton(
                        readingBook,
                        collectSentence: collect
                    )
                }
            }
            .padding(.bottom, 40)
        }
    }
}

extension ReadingBookCollectSentencesView {
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
        ReadingBookCollectSentencesView(readingBook: CompleteBook.preview)
    }
}
