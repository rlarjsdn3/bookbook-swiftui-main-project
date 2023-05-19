//
//  readingRecords.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/11.
//

import Foundation
import RealmSwift

class ReadingRecord: EmbeddedObject {
    @Persisted var date: Date           // 읽은 날짜
    @Persisted var totalPagesRead: Int  // 지금까지 읽은 페이지 쪽 수
    @Persisted var numOfPagesRead: Int  // 그 날에 읽은 페이지 쪽 수
}
