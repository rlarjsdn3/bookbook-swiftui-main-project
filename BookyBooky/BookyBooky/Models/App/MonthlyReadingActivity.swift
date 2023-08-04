//
//  MonthlyReadingActivity.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/18.
//

import Foundation

struct MonthlyReadingActivity {
    var month: Date
    var activities: [ReadingActivityData]
}

extension MonthlyReadingActivity {
    var totalPagesRead: Int {
        activities.reduce(0, { $0 + $1.numOfPagesRead })
    }
    
    var numOfCompleteReading: Int {
        activities.reduce(0, { $1.isComplete ? $0 + 1 : $0 })
    }
    
    var readingDayCount: Int {
        var date: [Date] = []
        
        for activity in self.activities {
            if !date.contains(
                where: { $0.isEqual([.year, .month, .day], date: activity.date) }
            ) {
                date.append(activity.date)
            }
        }
        return date.count
    }
    
    var averageDailyReadingPage: Int {
        totalPagesRead / readingDayCount
    }
}

extension MonthlyReadingActivity: Hashable { }
