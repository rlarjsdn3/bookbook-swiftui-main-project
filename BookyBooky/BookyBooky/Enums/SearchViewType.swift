//
//  SearchViewType.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/06.
//

import Foundation

enum SearchViewType {
    case search
    case withBackButton(isbn13: String)
    case withoutBackButton(isbn13: String)
}
