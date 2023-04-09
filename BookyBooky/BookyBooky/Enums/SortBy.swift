//
//  SortBy.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/09.
//

import Foundation

enum SortBy: String, CaseIterable {
    case latestOrder = "최신순"
    case titleOrder = "제목순"
    case sellingPointOrder = "판매 포인트순"
}
