//
//  BookListViewData.swift
//  BookyBooky
//
//  Created by 김건우 on 7/6/23.
//

import SwiftUI

final class BookListViewData: ObservableObject {
    @Published var scrollYOffset: CGFloat = 0.0
    @Published var selectedListTab: BookListTab = .bestSeller
    @Published var selectedListTabFA: BookListTab = .bestSeller
}
