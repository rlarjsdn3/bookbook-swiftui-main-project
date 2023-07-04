//
//  HomeViewData.swift
//  BookyBooky
//
//  Created by 김건우 on 7/3/23.
//

import SwiftUI
import Foundation

final class HomeViewData: ObservableObject {
    
    @Namespace var namespace: Namespace.ID
    
    @Published var scrollYOffset: CGFloat = 0.0
    
    @Published var selectedBookSort: BookSortCriteria = .titleAscendingOrder
    @Published var selectedCategory: Category = .all
    @Published var selectedCategoryFA: Category = .all
    
}
