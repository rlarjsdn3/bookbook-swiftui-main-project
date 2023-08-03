//
//  ShearchSheetViewData.swift
//  BookyBooky
//
//  Created by 김건우 on 7/6/23.
//

import SwiftUI

final class SearchSheetViewData: ObservableObject {
    @Published var bookSearchResult: [SimpleBookInfo.Item] = [] // 검색 결과 리스트를 저장하는 변수
    @AppStorage("SearchResultListMode") var selectedListMode: ListMode = .list
    
    @Published var inputQuery = ""
    @Published var searchIndex = 1
    @Published var selectedCategory: Category = .all
    @Published var selectedCategoryFA: Category = .all
}
