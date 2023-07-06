//
//  ShearchSheetViewData.swift
//  BookyBooky
//
//  Created by 김건우 on 7/6/23.
//

import SwiftUI

final class SearchSheetViewData: ObservableObject {
    @AppStorage("SearchResultListMode") var selectedListMode: ListMode = .list
    
    @Published var inputQuery = ""
    @Published var searchIndex = 1
    @Published var selectedCategory: Category = .all
    @Published var selectedCategoryFA: Category = .all
}
