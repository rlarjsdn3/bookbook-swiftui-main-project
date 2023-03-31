//
//  StringExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import Foundation

extension String {
    /// 도서 제목을 반환하는 프로퍼티
    var originalTitle: String {
        return String(self.split(separator: " - ")[0])
    }
    
    /// 도서 부제를 반환하는 프로퍼티 (부제 없을 시, 빈 문자열 반환)
    var subTitle: String {
        let titles = self.split(separator: " - ")
        if titles.count > 1 {
            return String(titles[1])
        }
        return ""
    }
}
