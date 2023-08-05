//
//  ResultsExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/19.
//

import Foundation
import RealmSwift

extension Results<CompleteBook> {
    
    /// 도서 배열의 유형을 정의한 열거형입니다.
    enum ReadingBookType {
        case all
        case complete
        case unfinished
    }
    
    /// 첫 번쨰 매개변수로 주어진 ISBN13과 동일한 값을 가지는 객체를 반환하는 함수입니다.
    /// - Parameter isbn13: 도서의 ISBN13
    /// - Returns: CompleteBook 타입의 객체(없으면 nil)
    func firstObject(isbn13: String) -> CompleteBook? {
        if let book = self.first(where: { $0.isbn13 == isbn13 }) {
            return book
        }
        return nil
    }
    
    /// 첫 번재 매개변수로 주어진 유형의 도서 배열을 반환하는 함수입니다.
    /// - Parameter type: 도서 유형
    /// - Returns: CompleteBook 타입의 배열
    func get(of type: ReadingBookType) -> [CompleteBook] {
        switch type {
        case .all:
            return Array(self)
        case .complete:
            return self.filter { $0.isComplete }
        case .unfinished:
            return self.filter { !$0.isComplete }
        }
    }
    
    ///  첫번째 매개변수로 주어진 CompleteBook 도서 배열을 sort 매개변수로 주어진 기준에 맞추어 정렬된 배열을 반환하는 함수입니다.
    /// - Parameters:
    ///   - type: 도서 유형
    ///   - sort: 정렬 기준
    /// - Returns: CompleteBook 타입의 배열
    private func getSortReadingBooks(_ type: ReadingBookType, sort: BookSortCriteria) -> [CompleteBook] {
        let books = get(of: type)
        
        switch sort {
        case .titleAscendingOrder:
            return books.sorted { $0.title < $1.title }
        case .titleDescendingOrder:
            return books.sorted { $0.title > $1.title }
        case .authorAscendingOrder:
            return books.sorted { $0.author < $1.author }
        case .authorDescendingOrder:
            return books.sorted { $0.author > $1.author }
        }
    }
    
    ///  CompleteBook 타입의 배열을 sort 매개변수로 주어진 기준으로 정렬하고, 정렬한 배열을 category 매개변수로 주어진 기준으로 필터링한 배열을 반환하는 함수입니다.
    /// - Parameters:
    ///   - type: 도서 유형
    ///   - sort: 정렬 기준
    ///   - category: 필터링 기준
    /// - Returns: 정렬/필터링된 CompleteBook 타입의 배열
    func getFilteredReadingBooks(_ type: ReadingBookType, sort: BookSortCriteria, category: Category) -> [CompleteBook] {
        let sortedBooks = getSortReadingBooks(type, sort: sort)
        
        if category == .all {
            return sortedBooks.filter { !$0.isComplete }
        } else {
            return sortedBooks.filter { category == $0.category && !$0.isComplete }
        }
    }
    
    /// CompleteBook 타입의 배열을 sort 매개변수로 주어진 기준으로 정렬하고, 정렬한 배열을 query 매개변수로 주어진 기준으로 필터링한 배열을 반환하는 함수입니다.
    /// - Parameters:
    ///   - type: 도서 유형
    ///   - sort: 정렬 기준
    ///   - query: 필터링 기준
    /// - Returns: 정렬/필터링된 CompleteBook 타입의 배열
    func getFilteredReadingBooks(_ type: ReadingBookType, sort: BookSortCriteria, query: String = "") -> [CompleteBook] {
        let sortedBooks = getSortReadingBooks(type, sort: sort)
        
        if query.isEmpty {
            return sortedBooks
        } else {
            return sortedBooks.filter {
                $0.title.contains(query) || $0.author.contains(query)
            }
        }
    }
}

extension Results<CompleteBook> {
    /// 첫 번째 매개변수로 주어진 최근 N개의  활동 데이터를 반환하는 함수입니다. 매개변수에 아무 값도 전달하지 않으면 전체 활동 데이터를 반환합니다.
    /// - Returns: Activity 타입의 배열
    func getActivity(prefix index: Int? = nil) -> [Activity] {
        var activities: [Activity] = []
        
        for book in self {
            for record in book.records {
                activities.append(
                    Activity(
                        date: record.date,
                        title: book.title,
                        category: book.category,
                        itemPage: book.itemPage,
                        isbn13: book.isbn13,
                        numOfPagesRead: record.numOfPagesRead,
                        totalPagesRead: record.totalPagesRead
                    )
                )
            }
        }
        
        activities = activities.sorted(by: { $0.date > $1.date })
        
        if let index = index {
            activities = Array(activities.prefix(Swift.min(index, activities.count)))
        }
        
        return activities
    }
}

extension Results<FavoriteBook> {
    
    ///  sort 매개변수로 주어진 기준에 맞추어 정렬된 배열을 반환하는 함수입니다.
    /// - Parameters:
    ///   - sort: 정렬 기준
    /// - Returns: 정렬된 FavoriteBook 타입의 배열
    private func getSortFavoriteBooks(sort: BookSortCriteria) -> [FavoriteBook] {
        switch sort {
        case .titleAscendingOrder:
            return self.sorted { $0.title < $1.title }
        case .titleDescendingOrder:
            return self.sorted { $0.title > $1.title }
        case .authorAscendingOrder:
            return self.sorted { $0.author < $1.author }
        case .authorDescendingOrder:
            return self.sorted { $0.author > $1.author }
        }
    }
    
    /// FavoriteBook 타입의 배열을 sort 매개변수로 주어진 기준으로 정렬하고, 정렬한 배열을 query 매개변수로 주어진 기준으로 필터링한 배열을 반환하는 함수입니다.
    /// - Parameters:
    ///   - type: 도서 유형
    ///   - sort: 정렬 기준
    ///   - query: 필터링 기준
    /// - Returns: 정렬/필터링된 FavoriteBook 타입의 배열
    func getFilteredFavoriteBooks(sort: BookSortCriteria, query: String = "") -> [FavoriteBook] {
        let sortedBooks = getSortFavoriteBooks(sort: sort)
        
        if query.isEmpty {
            return sortedBooks
        } else {
            return sortedBooks.filter {
                $0.title.contains(query) || $0.author.contains(query)
            }
        }
    }
}
