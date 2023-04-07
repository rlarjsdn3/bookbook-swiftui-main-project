//
//  FavoriteBook.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/07.
//

import Foundation
import RealmSwift

class FavoriteBook: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String    // 제목
    @Persisted var author: String   // 저자
    @Persisted var isbn13: String   // ISBN-13
}
