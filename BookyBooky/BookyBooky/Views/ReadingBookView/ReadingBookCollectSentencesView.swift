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
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    var body: some View {
        ScrollView {
            ForEach(readingBook.collectSentences, id: \.self) { collect in
                SentenceCellButton(readingBook, collectSentence: collect)
            }
        }
        .padding(.bottom, 40)
    }
}

struct ReadingBookCollectSentencesView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookCollectSentencesView(readingBook: ReadingBook.preview)
    }
}
