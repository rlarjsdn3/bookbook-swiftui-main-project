//
//  TabItem.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI
import Foundation

enum TabItem: CaseIterable {
    case home
    case search
    case bookShelf
    case analysis
    
    var tabName: String {
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
    
    var tabIcon: String {
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
    
    var tabIconPressed: String {
        switch self {
        case .home:
            return "house.fill"
        case .search:
            return "magnifyingglass.circle.fill"
        case .bookShelf:
            return "books.vertical.fill"
        case .analysis:
            return "chart.bar.fill"
        }
    }
    
    var tabColor: Color {
        switch self {
        case .home, .search, .bookShelf, .analysis:
            return .gray
        }
    }
    
    var tabColorPressed: Color {
        switch self {
        case .home, .search, .bookShelf, .analysis:
            return .black
        }
    }
}
