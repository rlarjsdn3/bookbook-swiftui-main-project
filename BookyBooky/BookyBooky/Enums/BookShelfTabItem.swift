//
//  BookShelfTabItem.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import Foundation

enum BookShelfTabItem: CaseIterable {
    case myLibrary
    case sentence
    
    var name: String {
        switch self {
        case .myLibrary:
            return "내 서재"
        case .sentence:
            return "문장 수집"
        }
    }
}
