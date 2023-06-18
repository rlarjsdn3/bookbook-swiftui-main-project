//
//  SentenceSortCriteria.swift
//  BookyBooky
//
//  Created by 김건우 on 6/18/23.
//

import Foundation

enum SentenceSortCriteria: String, CaseIterable {
    case titleAscending
    case titleDescending
    
    var name: String {
        switch self {
        case .titleAscending:
            return "제목 오름차순"
        case .titleDescending:
            return "제목 내림차순"
        }
    }
}
