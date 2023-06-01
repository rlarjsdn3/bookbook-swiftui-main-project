//
//  CollectSentences.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/11.
//

import Foundation
import RealmSwift

class CollectSentences: EmbeddedObject {
    @Persisted var date: Date           // 수집 날짜
    @Persisted var page: Int            // 쪽수
    @Persisted var sentence: String     // 수집된 문장
}

extension CollectSentences {
    static var preview: CollectSentences {
        CollectSentences(value: [
            "date": Date(),
            "page": 100,
            "sentence": "남은 인생을 설탕물이나 팔면서 보내시겠습니까? 아니면 세상을 바꾸고 싶습니까?"
        ])
    }
}
