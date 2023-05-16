//
//  CompleteTargetBook.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/11.
//

import Foundation
import RealmSwift

protocol Book {
    var title: String { get set }
    var author: String { get set }
    var isbn13: String { get set }
}

class ReadingBook: Object, ObjectKeyIdentifiable, Book {
    @Persisted(primaryKey: true) var _id: ObjectId  // 주요 키
    @Persisted var title: String                    // 제목
    @Persisted var author: String                   // 저자
    @Persisted var publisher: String                // 출판사
    @Persisted var pubDate: Date                    // 출판일
    @Persisted var cover: String                    // 표지(링크)
    @Persisted var itemPage: Int                    // 페이지 쪽 수
    @Persisted var category: Category               // 카테고리
    @Persisted var introduction: String              // 상품 설명
    @Persisted var link: String                     // 상품 페이지 링크
    @Persisted var isbn13: String                   // ISBN-13
    
    @Persisted var readingRecords: List<ReadingRecords>     // 독서 기록
    @Persisted var collectSentences: List<CollectSentences> // 문장 수집
    
    @Persisted var startDate: Date                  // 시작 날짜
    @Persisted var completeDate: Date?              // 완독 날짜
    @Persisted var targetDate: Date                 // 목표 날짜
}

extension ReadingBook {
    /// 도서의 완독 여부에 따라 불린(Bool) 형을 반환합니다.
    var isComplete: Bool {
        // 독서 데이터가 하나라도 존재하는 경우
        if let lastRecord = self.readingRecords.last {
            // 마지막으로 읽은 도서 페이지와 도서 페이지가 동일한 경우
            return lastRecord.totalPagesRead == self.itemPage // True 반환
        // 독서 데이터가 존재하지 않는 경우
        } else {
            return false // False 반환
        }
    }
}

extension ReadingBook {
    static var preview: ReadingBook = ReadingBook(
        value: ["title": "Java의 정석",
                "author": "남궁성",
                "publisher": "도우출판",
                "pubDate": Date(timeIntervalSinceNow: -7 * 86400),
                "cover": "https://image.aladin.co.kr/product/7608/30/cover/8994492038_1.jpg",
                "itemPage": 1000,
                "category": Category.computer,
                "explanation": "설명",
                "link": "http://www.aladin.co.kr/shop/wproduct.aspx?ItemId=76083001&amp;partner=openAPI&amp;start=api",
                "isbn13": "9788994492032",
                "startDate": Date(),
                "targetDate": Date(timeIntervalSinceNow: 7 * 86400)] as [String : Any]
    )
}
