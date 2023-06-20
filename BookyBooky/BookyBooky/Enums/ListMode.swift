//
//  ListMode.swift
//  BookyBooky
//
//  Created by 김건우 on 6/20/23.
//

import Foundation

enum ListMode: String, CaseIterable {
    case grid = "격자 모드"
    case list = "리스트 모드"
    
    var name: String {
        switch self {
        case .grid:
            return "격자 모드"
        case .list:
            return "리스트 모드"
        }
    }
}
