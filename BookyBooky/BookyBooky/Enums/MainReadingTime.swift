//
//  MainReadingTime.swift
//  BookyBooky
//
//  Created by 김건우 on 6/16/23.
//

import SwiftUI

enum MainReadingTime {
    case morning
    case lunch
    case evening
    case dawn
    
    var name: String {
        switch self {
        case .morning:
            return "아침"
        case .lunch:
            return "점심"
        case .evening:
            return "저녁"
        case .dawn:
            return "새벽"
        }
    }
    
    var systemImage: String {
        switch self {
        case .morning:
            return "sunrise.circle.fill"
        case .lunch:
            return "sun.max.circle.fill"
        case .evening:
            return "moon.circle.fill"
        case .dawn:
            return "moon.stars.circle.fill"
        }
    }
    
    var themeColor: Color {
        switch self {
        case .morning:
            return Color.yellow
        case .lunch:
            return Color.orange
        case .evening:
            return Color.red
        case .dawn:
            return Color.black
        }
    }
}
