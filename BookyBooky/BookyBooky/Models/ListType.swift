//
//  ListType.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import Foundation

enum ListType: String, CaseIterable {
    case itemNewAll = "ItemNewAll"              // 신간 전체 리스트
    case itemNewSpecial = "ItemNewSpacial"      // 주목할 만한 신간 리스트
    case itemEditorChoice = "ItemEditorChoice"  // 편집자 추천 리스트
    case bestSeller = "Bestseller"              // 베스트셀러
    case blogBest = "BlogBest"
    
    var name: String {
        switch self {
        case .itemNewAll:
            return "신간 도서"
        case .itemNewSpecial:
            return "신간 베스트"
        case .itemEditorChoice:
            return "편집자 추천"
        case .bestSeller:
            return "베스트셀러"
        case .blogBest:
            return "블로거 추천"
        }
    }
}
