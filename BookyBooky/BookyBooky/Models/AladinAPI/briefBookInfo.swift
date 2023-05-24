//
//  BookSearch.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI

struct briefBookInfo: Codable {
    var totalResults: Int           // 검색 결과의 총 개수
    var startIndex: Int             // 현재 페이지 수
    
    var item: [Item]
    struct Item: Codable, Hashable {
        var title: String           // 제목
        var author: String          // 저자
        var publisher: String       // 출판사
        var pubDate: String         // 출판일
        var cover: String           // 커버(표지)
        var categoryName: String    // 카테고리 분류
        var isbn13: String          // ISBN-13
    }
}

// MARK: - EXTENSIONS

extension briefBookInfo.Item {
    var bookCategory: CategoryType {
        return categoryName.refinedCategory
    }
    
    var bookTitle: String {
        return title.refinedTitle
    }
    
    var bookAuthor: String {
        return author.refinedAuthor
    }
    
    var bookPublisher: String {
        return publisher
    }
    
    var bookPubDate: Date {
        return pubDate.refinedPublishDate
    }
}

extension briefBookInfo.Item {
    static var preview: briefBookInfo.Item = .init(
        title: "Java의 정석 - 3rd Edition",
        author: "남궁성 (지은이)",
        publisher: "도우출판",
        pubDate: "2016-01-28",
        cover: "https://image.aladin.co.kr/product/22460/28/cover/8994492046_1.jpg",
        categoryName: "국내도서>컴퓨터/모바일>프로그래밍 언어>자바",
        isbn13: "9788994492049"
    )
}
