//
//  ListType.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import Foundation

enum ListType: String {
    case itemNewAll = "ItemNewAll"              // 신간 전체 리스트
    case itemNewSpecial = "ItemNewSpacial"      // 주목할 만한 신간 리스트
    case itemEditorChoice = "ItemEditorChoice"  // 편집자 추천 리스트
    case bestSeller = "Bestseller"              // 베스트셀러
    case blogBest = "BlogBest"                  // 블로그 베스트셀러
}
