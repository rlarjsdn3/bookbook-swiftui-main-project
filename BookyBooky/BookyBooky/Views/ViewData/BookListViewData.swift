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
    
    @Published var bestSeller: [briefBookItem.Item] = []     // 베스트셀러 리스트를 저장하는 변수
    @Published var itemNewAll: [briefBookItem.Item] = []     // 신간 도서 리스트를 저장하는 변수
    @Published var itemNewSpecial: [briefBookItem.Item] = [] // 신간 베스트 리스트를 저장하는 변수
    @Published var blogBest: [briefBookItem.Item] = []       // 블로그 베스트 리스트를 저장하는 변수
    
    @Published var searchResults: [briefBookItem.Item] = [] // 검색 결과 리스트를 저장하는 변수
    @Published var searchBookInfo: detailBookItem.Item?     // 상세 도서 결과값을 저장하는 변수
}
