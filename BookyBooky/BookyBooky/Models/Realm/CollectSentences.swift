//
//  CollectSentences.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/11.
//

import Foundation
import RealmSwift

class CollectSentences: EmbeddedObject {
    @Persisted var date: String         // 수집 날짜
    @Persisted var sentence: String     // 수집된 문장
}
