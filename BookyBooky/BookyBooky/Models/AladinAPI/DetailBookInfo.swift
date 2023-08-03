//
//  BookDetail.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import Foundation
import RealmSwift

// MARK: - STRUCT

struct DetailBookInfo: Codable {
    var totalResults: Int           // 검색 결과의 총 개수
    
    var item: [Item]
    struct Item: Codable {
        var title: String           // 제목
        var author: String          // 저자
        var publisher: String       // 출판사
        var pubDate: String         // 출판일
        var cover: String           // 커버(표지)
        var description: String     // 설명
        var link: String            // 상세 페이지
        var categoryName: String    // 카테고리 분류
        var salesPoint: Int         // 판매 포인트
        var isbn13: String          // ISBN-13
        
        var subInfo: SubInfo
        struct SubInfo: Codable {
            var itemPage: Int       // 상품의 총 페이지
        }
    }
}

// MARK: - EXTENSIONS

extension DetailBookInfo.Item {
    var bookCategory: Category {
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
    
    var bookDescription: String {
        return self.description.isEmpty ? "(설명 없음)" : description
    }
}

extension DetailBookInfo.Item {
    static var preview: DetailBookInfo.Item = .init(
        title: "Java의 정석 - 3rd Edition",
        author: "남궁성 (지은이)",
        publisher: "도우출판",
        pubDate: "2016-01-28",
        cover: "https://image.aladin.co.kr/product/22460/28/cover/8994492046_1.jpg",
        description: "저자는 자바를 소개하는데 그치지 않고 프로그래머로써 꼭 알아야하는 내용들을 체계적으로 정리하였으며 200페이지에 달하는 지면을 객체지향개념에 할애함으로써 이 책 한 권이면 객체지향개념을 완전히 이해할 수 있도록 원리중심으로 설명하고 있다.",
        link: "http://www.aladin.co.kr/shop/wproduct.aspx?ItemId=76083001&amp;partner=openAPI&amp;start=api",
        categoryName: "국내도서>컴퓨터/모바일>프로그래밍 언어>자바",
        salesPoint: 16494,
        isbn13: "9788994492032",
        subInfo: .init(
            itemPage: 1022
        )
    )
}
