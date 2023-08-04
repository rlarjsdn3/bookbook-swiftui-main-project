//
//  ChartData.swift
//  BookyBooky
//
//  Created by 김건우 on 6/24/23.
//

// NOTICE: - 본 파일에 구현된 기능은 아직 미완성입니다.

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
