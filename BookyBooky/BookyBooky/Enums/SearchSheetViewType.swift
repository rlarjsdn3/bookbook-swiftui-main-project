//
//  SearchViewType.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/06.
//

import Foundation

enum SearchSheetViewType {
    case search(isbn13: String)
    case favorite(isbn13: String)
}
