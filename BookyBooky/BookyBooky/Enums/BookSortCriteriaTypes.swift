//
//  SortBy.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/09.
//

import Foundation

enum BookSortCriteriaTypes: String, CaseIterable {
    case latestOrder = "최신순"
    case titleOrder = "제목순"
    case authorOrder = "저자순"
    
    // NOTE: - 추후 업데이트 시, '오래된순', '제목 내림차순', '제목 오름차순', '저자 오름차순', '저자 내림차순' 등 정렬 기준 추가
}
