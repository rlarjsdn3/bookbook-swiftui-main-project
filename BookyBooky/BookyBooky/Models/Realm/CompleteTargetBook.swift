//
//  CompleteTargetBook.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/11.
//

import Foundation
import RealmSwift

class CompleteTargetBook: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId  // 주요 키
    @Persisted var title: String                    // 제목
    @Persisted var author: String                   // 저자
    @Persisted var pubDate: Date                    // 출판일
    @Persisted var cover: String                    // 표지(링크)
    @Persisted var itemPage: Int                    // 페이지 쪽 수
    @Persisted var category: String                 // 카테고리
    @Persisted var link: String                     // 상품 페이지 링크
    @Persisted var isbn13: String                   // ISBN-13
    
    @Persisted var readingRecords = List<ReadingRecords>()      // 독서 기록
    @Persisted var collectSentences = List<CollectSentences>()  // 문장 수집
    
    @Persisted var startDate: Date                  // 시작 날짜
    @Persisted var targetDate: Date                 // 목표 날짜
    
    @Persisted var isCompleted: Bool                // 완독 여부
}
