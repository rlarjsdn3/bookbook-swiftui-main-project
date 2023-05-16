//
//  SortBy.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/09.
//

import Foundation

enum BookSortCriteriaType: String, CaseIterable {
    case latestOrder = "최신순"
    case titleOrder = "제목순"
    case authorOrder = "저자순"
}
