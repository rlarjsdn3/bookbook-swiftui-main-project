//
//  BookDetail.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import Foundation

struct BookDetail: Codable {
    var totalResults: Int // API 결과의 제목
    
    var item: [Item]
    struct Item: Codable {
        var title: String
        var author: String
        var publisher: String
        var pubDate: String
        var cover: String
        var description: String
        var link: String
        var categoryName: String
        
        var subInfo: SubInfo
        struct SubInfo: Codable {
            var originalTitle: String
            var subTitle: String
            var itemPage: Int
        }
    }
}
