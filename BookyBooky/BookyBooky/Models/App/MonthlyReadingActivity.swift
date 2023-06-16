//
//  MonthlyReadingActivity.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/18.
//

import Foundation

struct MonthlyReadingActivity: Hashable {
    var month: Date
    var readingActivity: [ReadingActivity]
}

extension MonthlyReadingActivity {
    var totalPagesRead: Int {
        readingActivity.reduce(0, { $0 + $1.numOfPagesRead })
    }
    
    var completeBookCount: Int {
        readingActivity.reduce(0, { $1.isComplete ? $0 + 1 : $0 })
    }
    
    var readingDayCount: Int {
        var date: [Date] = []
        
        for activity in self.readingActivity {
            if !date.contains(
                where: { $0.isEqual([.year, .month, .day], date: activity.date) }
            ) {
                date.append(activity.date)
            }
        }
        return date.count
    }
    
    var averagePagesRead: Int {
        totalPagesRead / readingDayCount
    }
}
