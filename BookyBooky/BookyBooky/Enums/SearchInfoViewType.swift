//
//  SearchInfoViewType.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/06.
//

import Foundation

enum SearchInfoViewType {
    case withBackbutton(isbn13: String)
    case withoutBackbutton(isbn13: String)
}
