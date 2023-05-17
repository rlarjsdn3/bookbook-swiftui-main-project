//
//  RealmSwiftExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/16.
//

import Foundation
import RealmSwift

extension RealmSwift.Results {
    
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
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
