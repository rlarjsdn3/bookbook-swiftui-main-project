//
//  TabItem.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI
import Foundation

enum CustomMainTab: CaseIterable {
    case home, search, bookShelf, analysis
    
    var name: String {
        switch self {
        case .home:
            return "홈"
        case .search:
            return "검색"
        case .bookShelf:
            return "책장"
        case .analysis:
            return "분석"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .search:
            return "magnifyingglass.circle"
        case .bookShelf:
            return "books.vertical"
        case .analysis:
            return "chart.bar"
        }
    }
    
    var color: Color {
        switch self {
        case .home, .search, .bookShelf, .analysis:
            return .gray
        }
    }
    
    var colorPressed: Color {
        switch self {
        case .home, .search, .bookShelf, .analysis:
            return .black
        }
    }
}
