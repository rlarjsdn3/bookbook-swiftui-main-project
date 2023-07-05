//
//  HomeViewData.swift
//  BookyBooky
//
//  Created by 김건우 on 7/3/23.
//

import SwiftUI
import RealmSwift

final class HomeViewData: ObservableObject {
    @Published var activityData: [ReadingActivity] = []
    
    @Published var scrollYOffset: CGFloat = 0.0
    @Published var selectedBookSort: BookSortCriteria = .titleAscendingOrder
    @Published var selectedCategory: Category = .all
    @Published var selectedCategoryFA: Category = .all
    
    func getActivityData(_ completeBooks: Results<CompleteBook>) {
        activityData = completeBooks.recentReadingActivity
    }
}
