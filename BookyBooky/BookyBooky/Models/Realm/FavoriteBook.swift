//
//  FavoriteBook.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/07.
//

import Foundation
import RealmSwift

class FavoriteBook: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId  // 주요 키
    @Persisted var title: String        // 제목
    @Persisted var author: String       // 저자
    @Persisted var cover: String        // 표지(커버)
    @Persisted var category: CategoryTypes // 카테고리
    @Persisted var salesPoint: String  // 판매 포인트
    @Persisted var isbn13: String       // ISBN-13
}
