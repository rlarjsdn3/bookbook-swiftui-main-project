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
    
    /// 매개변수로 주어진 도서의 ISBN13과 동일한 값을 가지는 객체를 반환하는 함수입니다. 해당하는 객체가 존재하지 않는다면 nil을 반환합니다.
    /// - Parameter isbn13: 찾고자 하는 도서의 ISBN13
    /// - Returns: ReadingBook 타입의 Obect 객체
    func firstObject(isbn13: String) -> CompleteBook? {
        if let book = self.first(where: { $0.isbn13 == isbn13 }) {
            return book
        }
        return nil
    }
    
    /// 도서 배열을 반환하는 함수입니다.
    /// 모든 도서(.all)를 반환하거나, 읽고 있는 도서(.unfinished) 혹은 읽은 도서(.complete)를 반환합니다.
    /// - Parameter type: 도서 유형(.all, .complete, .unfinished)
    /// - Returns: ReadingBook 형의 배열
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
    
    ///  첫번째 매개변수로 주어진 ReadingBooks 도서 배열을 sortType 매개변수로 주어진 기준에 맞추어 정렬된 배열을 반환하는 함수입니다.
    /// - Parameters:
    ///   - sortType: 정렬 기준
    /// - Returns: 정렬된 Book 프로토콜을 준수하는 도서 배열
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
    
    ///  ReadingBook 형의 배열을 bookSort 매개변수로 주어진 기준으로 정렬하고, 정렬한 배열을 categoryType 매개변수로 주어진 기준으로 필터링한 배열을 반환하는 함수입니다.
    /// - Parameters:
    ///   - bookSortType: 도서 정렬 기준
    ///   - categoryType: 도서 필터 기준 (카테고리 별)
    /// - Returns: 정렬 및 필터링된 ReadingBook 형의 배열
    func getFilteredReadingBooks(_ type: ReadingBookType, sort: BookSortCriteria, category: Category) -> [CompleteBook] {
        let sortedBooks = getSortReadingBooks(type, sort: sort)
        
        if category == .all {
            return sortedBooks.filter { !$0.isComplete }
        } else {
            return sortedBooks.filter { category == $0.category && !$0.isComplete }
        }
    }
    
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
    /// 최근 index개의 활동 데이터를 반환하는 함수입니다.
    /// - Returns: Activity 형의 배열
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
    ///  첫번째 매개변수로 주어진 ReadingBooks 도서 배열을 sortType 매개변수로 주어진 기준에 맞추어 정렬된 배열을 반환하는 함수입니다.
    /// - Parameters:
    ///   - sortType: 정렬 기준
    /// - Returns: 정렬된 Book 프로토콜을 준수하는 도서 배열
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
