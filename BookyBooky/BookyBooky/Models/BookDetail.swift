//
//  BookDetail.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import Foundation

struct BookDetail: Codable {
    var totalResults: Int           // 검색 결과의 총 개수
    
    var item: [Item]
    struct Item: Codable {
        var title: String?          // 제목
        var author: String?         // 저자
        var publisher: String?      // 출판사
        var pubDate: String?        // 출판일
        var cover: String?          // 커버(표지)
        var description: String?    // 설명
        var link: String?           // 상세 페이지
        var categoryName: String?   // 카테고리 분류
        var salesPoint: Int?        // 세일즈 포인트
        
        var subInfo: SubInfo
        struct SubInfo: Codable {
            var itemPage: Int?      // 상품의 총 페이지
        }
    }
}
