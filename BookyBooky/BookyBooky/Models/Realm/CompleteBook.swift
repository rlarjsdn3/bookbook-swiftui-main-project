//
//  CompleteTargetBook.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/11.
//

import Foundation
import RealmSwift

class CompleteBook: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId  // 주요 키
    @Persisted var title: String                    // 제목
    @Persisted var author: String                   // 저자
    @Persisted var publisher: String                // 출판사
    @Persisted var pubDate: Date                    // 출판일
    @Persisted var cover: String                    // 표지(링크)
    @Persisted var itemPage: Int                    // 페이지 쪽 수
    @Persisted var category: Category               // 카테고리
    @Persisted var desc: String                     // 상품 설명
    @Persisted var link: String                     // 상품 페이지 링크
    @Persisted var isbn13: String                   // ISBN-13
    
    @Persisted var records: List<Record>     // 독서 기록
    @Persisted var sentences: List<Sentence> // 문장 수집
    
    @Persisted var startDate: Date                  // 시작 날짜
    @Persisted var completeDate: Date?              // 완독 날짜
    @Persisted var targetDate: Date                 // 목표 날짜
}

extension CompleteBook {
    /// 도서의 완독 여부에 따라 불린(Bool) 형을 반환하는 계산 프로퍼티입니다.
    /// 완독한 경우, 참(True)을 반환합니다.
    var isComplete: Bool {
        // 독서 데이터가 하나라도 존재하는 경우
        if let lastRecord = self.records.last {
            // 마지막으로 읽은 도서 페이지와 도서 페이지가 동일한 경우
            return lastRecord.totalPagesRead == self.itemPage // True 반환
        // 독서 데이터가 존재하지 않는 경우
        } else {
            return false // False 반환
        }
    }
    
    /// 도서의 제일 마지막 독서 기록을 반환하는 계산 프로퍼티입니다.
    /// 독서 기록이 없는 경우 nil을 반환합니다.
    var lastRecord: Record? {
        if let lastRecord = self.records.last {
            return lastRecord
        }
        return nil
    }
    
    /// 전체 페이지 중 얼마나 읽었는지 진척도 비율(%)을 반환하는 계산 프로퍼티입니다.
    var readingProgressRate: Double {
        if let lastRecord = self.lastRecord {
            return (Double(lastRecord.totalPagesRead) / Double(self.itemPage)) * 100.0
        } else {
            return 0.0
        }
    }
    
    /// 전체 페이지 중 얼마나 읽었는지 도서 페이지를 반환하는 계산 프로퍼티입니다.
    var readingProgressPage: Int {
        if let readingRecord = self.lastRecord {
            return readingRecord.totalPagesRead
        } else {
            return 0
        }
    }
    
    /// 도서의 완독 목표 일자를 초과했는지 확인하여 불린(Bool) 형을 반환하는 계산 프로퍼티입니다.
    /// 오늘 일자가 도서의 완독 목표 일자보다 같거나 더 빠르면 거짓(False)을, 초과하면 참(True)를 반환합니다.
    var isBehindTargetDate: Bool {
        switch Date().compare(self.targetDate) {
        // 오늘 일자가 도서의 완독 목표 일자보다 같거나 더 빠르면
        case .orderedAscending, .orderedSame:
            return false // False 반환
        // 오늘 일자가 도서의 완독 목표 일자보다 초과하면
        case .orderedDescending:
            return true // True 반환
        }
    }
    
    var bookDescription: String {
        return self.desc.isEmpty ? "(설명 없음)" : description
    }
}

extension CompleteBook {
    static var preview = CompleteBook(
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
