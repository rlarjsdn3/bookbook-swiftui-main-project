//
//  ChartData.swift
//  BookyBooky
//
//  Created by 김건우 on 6/24/23.
//

import Foundation

struct ChartData {
    struct TotalPagesReadByCategory: Identifiable, Hashable {
        var category: Category
        var pages: Int
        
        var id: Category { category }
    }

    struct DailyPagesRead: Identifiable, Hashable {
        var date: Date
        var pages: Int
        
        var id: Date { date }
    }

    struct MonthlyCompleteBook: Identifiable, Hashable {
        var date: Date
        var count: Int
        
        var id: Date { date }
    }
}
