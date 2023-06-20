//
//  ChartTimeRange.swift
//  BookyBooky
//
//  Created by 김건우 on 6/20/23.
//

import Foundation

enum ChartTimeRange: String, CaseIterable {
    case last14Days
    case last180Days
    
    var name: String {
        switch self {
        case .last14Days:
            return "2주"
        case .last180Days:
            return "6개월"
        }
    }
}
