//
//  MonthlyReadingActivity.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/18.
//

import Foundation

struct MonthlyActivity {
    var date: String
    var activities: [Activity]
}

extension MonthlyActivity {
    var totalPagesRead: Int {
        activities.reduce(0, { $0 + $1.numOfPagesRead })
    }
    
    var numOfCompleteReading: Int {
        activities.reduce(0, { $1.isComplete ? $0 + 1 : $0 })
    }
    
    var readingDayCount: Int {
        var date: [Date] = []
        
        for activity in activities {
            if !date.contains(
                where: { $0.isEqual([.year, .month, .day], with: activity.date) }
            ) {
                date.append(activity.date)
            }
        }
        print(date)
        return date.count
    }
    
    var averageDailyReadingPage: Int {
        totalPagesRead / readingDayCount
    }
}

extension MonthlyActivity: Hashable { }
