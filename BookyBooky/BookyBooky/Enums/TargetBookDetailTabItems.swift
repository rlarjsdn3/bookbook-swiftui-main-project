//
//  TargetBookDetailTabItems.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/01.
//

import Foundation

enum TargetBookDetailTabItems: CaseIterable {
    case overview
    case analysis
    case collectSentences
    case recordReadings
    
    var name: String {
        switch self {
        case .overview:
            return "개요"
        case .analysis:
            return "분석"
        case .collectSentences:
            return "문장 수집"
        case .recordReadings:
            return "독서 기록"
        }
    }
}
