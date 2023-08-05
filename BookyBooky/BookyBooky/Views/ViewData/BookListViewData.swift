//
//  BookListViewData.swift
//  BookyBooky
//
//  Created by 김건우 on 7/6/23.
//

import SwiftUI

final class BookListViewData: ObservableObject {
    @Published var scrollYOffset: CGFloat = 0.0
    @Published var selectedListTab: BookListType = .bestSeller
    @Published var selectedListTabFA: BookListType = .bestSeller
    
    @Published var bestSeller: [SimpleBookInfo.Item] = []     // 베스트셀러 리스트를 저장하는 변수
    @Published var itemNewAll: [SimpleBookInfo.Item] = []     // 신간 도서 리스트를 저장하는 변수
    @Published var itemNewSpecial: [SimpleBookInfo.Item] = [] // 신간 베스트 리스트를 저장하는 변수
    @Published var blogBest: [SimpleBookInfo.Item] = []       // 블로그 베스트 리스트를 저장하는 변수
    
    @Published var searchResults: [SimpleBookInfo.Item] = [] // 검색 결과 리스트를 저장하는 변수
    @Published var searchBookInfo: DetailBookInfo.Item?     // 상세 도서 결과값을 저장하는 변수
}
