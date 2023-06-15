//
//  SortBy.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/09.
//

import Foundation

enum BookSortCriteria: CaseIterable {
    case titleAscendingOrder
    case titleDescendingOrder
    case authorAscendingOrder
    case authorDescendingOrder
    
    var name: String {
        switch self {
        case .titleAscendingOrder:
            return "제목 오름차순"
        case .titleDescendingOrder:
            return "제목 내림차순"
        case .authorAscendingOrder:
            return "저자 오름차순"
        case .authorDescendingOrder:
            return "저자 내림차순"
        }
    }
}

extension BookSortCriteria: Identifiable {
    var id: String { self.name }
}
