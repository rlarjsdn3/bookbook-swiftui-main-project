//
//  Activity.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/12.
//

import Foundation

struct Activity: Hashable {
    var date: Date
    var title: String
    var category: CategoryTypes
    var itemPage: Int
    var isbn13: String
    
    var numOfPagesRead: Int
    var totalPagesRead: Int
}

extension Activity {
    /// 도서의 완독 여부에 따라 불린(Bool) 형을 반환합니다.
    var isComplete: Bool {
        // 마지막으로 읽은 도서 페이지와 도서 페이지가 동일한 경우
        return itemPage == totalPagesRead // True 반환
    }
}

extension Activity {
    static var preview: Activity = Activity(
                                        date: Date.now,
                                        title: "Java의 정석",
                                        category: CategoryTypes.computer,
                                        itemPage: 300,
                                        isbn13: "123456789012",
                                        numOfPagesRead: 3,
                                        totalPagesRead: 3
                                    )
}
