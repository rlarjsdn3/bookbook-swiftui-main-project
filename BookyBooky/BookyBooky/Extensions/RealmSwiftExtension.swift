//
//  RealmSwiftExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/16.
//

import Foundation
import RealmSwift

extension RealmSwift.Results where Element: Book {
    func findFirst<T>(with isbn13: String) -> T? {
        if let book = self.first(where: { $0.isbn13 == isbn13 }) {
            return book as? T
        } else {
            return nil
        }
    }
}
