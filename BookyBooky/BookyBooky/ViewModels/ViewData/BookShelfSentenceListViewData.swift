//
//  BookShelfSentenceListViewData.swift
//  BookyBooky
//
//  Created by 김건우 on 7/6/23.
//

import SwiftUI

final class BookShelfSentenceListViewData: ObservableObject {
    @Published var inputQuery = ""
    @Published var searchQuery = ""
    @Published var selectedSort: BookSortCriteria = .titleAscendingOrder
    
    @Published var  isPresentingShowAllButton = false
}
