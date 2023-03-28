//
//  BookSearch.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI
import Foundation

struct BookSearch: Codable {
    var totalResults: Int           // 검색 결과의 총 개수
    
    var item: [Item]
    struct Item: Codable, Hashable {
        var title: String?          // 제목
        var author: String?         // 저자
        var publisher: String?      // 출판사
        var pubDate: String?        // 출판일
        var cover: String?          // 커버(표지)
        var categoryName: String?   // 카테고리 분류
        var isbn13: String?         // ISBN-13
    }
}

extension BookSearch {
    static var preview: BookSearch {
        BookSearch(
            totalResults: 1,
            item: [
                .init(
                    title: "아라비안 나이트",
                    author: "작자 미상",
                    publisher: "삼성출판사",
                    pubDate: "2016-03-01",
                    cover: "https://image.aladin.co.kr/product/10917/74/cover/8915104323_1.jpg",
                    categoryName: "국내도서>어린이",
                    isbn13: "9788915104327")
            ]
        )
    }
}
