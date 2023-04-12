//
//  BookShelfSummaryItems.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/12.
//

import SwiftUI
import RealmSwift

enum BookShelfSummaryItems: CaseIterable {
    case completeBooksCount
    case favoriteBooksCount
    case collectSentencesCount
    
    var name: String {
        switch self {
        case .completeBooksCount:
            return "읽은 도서 수"
        case .favoriteBooksCount:
            return "찜한 도서 수"
        case .collectSentencesCount:
            return "수집 문장 수"
        }
    }
    
    var systemImage: String {
        switch self {
        case .completeBooksCount:
            return "book"
        case .favoriteBooksCount:
            return "heart.fill"
        case .collectSentencesCount:
            return "bookmark.fill"
        }
    }
    
    var color: AnyGradient {
        switch self {
        case .completeBooksCount:
            return Color.blue.gradient
        case .favoriteBooksCount:
            return Color.pink.gradient
        case .collectSentencesCount:
            return Color.green.gradient
        }
    }
}
