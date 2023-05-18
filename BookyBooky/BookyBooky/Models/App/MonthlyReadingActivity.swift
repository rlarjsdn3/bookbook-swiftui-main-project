//
//  MonthlyReadingActivity.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/18.
//

import Foundation

struct MonthlyReadingActivity: Hashable {
    var date: Date
    var activities: [ReadingActivity]
}
