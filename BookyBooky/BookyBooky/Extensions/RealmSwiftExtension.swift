//
//  RealmSwiftExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/16.
//

import Foundation
import RealmSwift

extension RealmSwift.Results {
    /// 매개변수로 주어진 도서의 ISBN13과 동일한 값을 가지는 객체를 반환하는 함수입니다. 해당하는 객체가 존재하지 않는다면 nil을 반환합니다.
    /// - Parameter isbn13: 찾고자 하는 도서의 ISBN13
    /// - Returns: Book 프로토콜을 준수하는 Obect 객체
    func findFirst<T: RealmCollectionValue>(with isbn13: String) -> T? where Element: Book {
        if let book = self.first(where: { $0.isbn13 == isbn13 }) {
            return book as? T
        } else {
            return nil
        }
    }
    
//    func sort<T>(_ type: BookSort) -> [T]? where T: RealmCollectionValue, Element: Book {
//        switch type {
//        case .latestOrder:
//            return self.reversed()
//        case .titleOrder:
//            return self.sorted { $0.title > $1.title }
//        case .authorOrder:
//            return self.sorted { $0.author > $1.author }
//        }
//    }
}
