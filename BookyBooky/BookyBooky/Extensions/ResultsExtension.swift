//
//  ResultsExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/19.
//

import Foundation
import RealmSwift

extension Results<ReadingBook> {
    /// 도서 배열의 유형을 정의한 열거형입니다.
    enum ReadingBookType {
        case all
        case complete
        case unfinished
    }
    
    /// 매개변수로 주어진 도서의 ISBN13과 동일한 값을 가지는 객체를 반환하는 함수입니다. 해당하는 객체가 존재하지 않는다면 nil을 반환합니다.
    /// - Parameter isbn13: 찾고자 하는 도서의 ISBN13
    /// - Returns: ReadingBook 타입의 Obect 객체
    func findFirst(isbn13: String) -> ReadingBook? {
        if let readingBook = self.first(where: { $0.isbn13 == isbn13 }) {
            return readingBook
        }
        return nil
    }
    
    /// 매개변수로 주어진 도서의  키 값(ID)과 동일한 값을 가지는 객체를 반환하는 함수입니다. 해당하는 객체가 존재하지 않는다면 nil을 반환합니다.
    /// - Parameter isbn13: 찾고자 하는 도서의 키 값(ID)
    /// - Returns: ReadingBook타입의 Obect 객체
    func findReadingBookFirst(id: ObjectId) -> ReadingBook? {
        if let readingBook = self.first(where: { $0._id == id }) {
            return readingBook
        }
        return nil
    }
    
    /// 도서 배열을 반환하는 함수입니다.
    /// 모든 도서(.all)를 반환하거나, 읽고 있는 도서(.unfinished) 혹은 읽은 도서(.complete)를 반환합니다.
    /// - Parameter type: 도서 유형(.all, .complete, .unfinished)
    /// - Returns: ReadingBook 형의 배열
    func get(_ type: ReadingBookType) -> [ReadingBook] {
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
    private func getSortReadingBooks(_ bookType: ReadingBookType, sort: BookSortCriteria) -> [ReadingBook] {
        let readingBookArray = get(bookType)
        
        switch sort {
        case .titleAscendingOrder:
            return readingBookArray.sorted { $0.title < $1.title }
        case .titleDescendingOrder:
            return readingBookArray.sorted { $0.title > $1.title }
        case .authorAscendingOrder:
            return readingBookArray.sorted { $0.author < $1.author }
        case .authorDescendingOrder:
            return readingBookArray.sorted { $0.author > $1.author }
        }
    }
    
    ///  ReadingBook 형의 배열을 bookSort 매개변수로 주어진 기준으로 정렬하고, 정렬한 배열을 categoryType 매개변수로 주어진 기준으로 필터링한 배열을 반환하는 함수입니다.
    /// - Parameters:
    ///   - bookSortType: 도서 정렬 기준
    ///   - categoryType: 도서 필터 기준 (카테고리 별)
    /// - Returns: 정렬 및 필터링된 ReadingBook 형의 배열
    func getFilteredReadingBooks(_ bookType: ReadingBookType, sort: BookSortCriteria, category: Category) -> [ReadingBook] {
        let sortedBookArray = getSortReadingBooks(bookType, sort: sort)
        
        if category == .all {
            return sortedBookArray.filter { !$0.isComplete }
        } else {
            return sortedBookArray.filter { category == $0.category && !$0.isComplete }
        }
    }
    
    func getFilteredReadingBooks(_ bookType: ReadingBookType, searchQuery: String = "", bookSortType: BookSortCriteria) -> [ReadingBook] {
        let sortedBookArray = getSortReadingBooks(bookType ,sort: bookSortType)
        
        if searchQuery.isEmpty {
            return sortedBookArray
        } else {
            return sortedBookArray.filter {
                $0.title.contains(searchQuery) || $0.author.contains(searchQuery)
            }
        }
    }
}

extension Results<ReadingBook> {
    /// 최근 3개의 활동 데이터를 반환하는 함수입니다.
    /// - Returns: Activity 형의 배열
    var recentReadingActivity: [ReadingActivity] {
        var activities: [ReadingActivity] = []
        
        for readingBook in self {
            for record in readingBook.readingRecords {
                activities.append(
                    ReadingActivity(
                        date: record.date,
                        title: readingBook.title,
                        category: readingBook.category,
                        itemPage: readingBook.itemPage,
                        isbn13: readingBook.isbn13,
                        numOfPagesRead: record.numOfPagesRead,
                        totalPagesRead: record.totalPagesRead
                    )
                )
            }
        }
        
        return Array(
            activities.sorted { $0.date > $1.date }.prefix(Swift.min(activities.count, 3))
        )
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    var monthlyReadingActivity: [MonthlyReadingActivity] {
        var monthlyRecord: [MonthlyReadingActivity] = []
        
        for readingBook in self {
            for record in readingBook.readingRecords {
                let activity = ReadingActivity(
                                    date: record.date,
                                    title: readingBook.title,
                                    category: readingBook.category,
                                    itemPage: readingBook.itemPage,
                                    isbn13: readingBook.isbn13,
                                    numOfPagesRead: record.numOfPagesRead,
                                    totalPagesRead: record.totalPagesRead
                                )
                
                if let index = monthlyRecord.firstIndex(where: {
                    $0.month.isEqual([.year, .month], date: record.date)
                }) {
                    monthlyRecord[index].readingActivity.append(activity)
                } else {
                    monthlyRecord.append(
                        MonthlyReadingActivity(
                            month: record.date,
                            readingActivity: [activity]
                        )
                    )
                }
            }
        }
        
        for index in monthlyRecord.indices {
            monthlyRecord[index].readingActivity.sort { $0.date < $1.date }
        }
        monthlyRecord.sort { $0.month > $1.month }
        
        return monthlyRecord
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
    
    func getFilteredFavoriteBooks(searchQuery: String = "", bookSortType: BookSortCriteria) -> [FavoriteBook] {
        let sortedBookArray = getSortFavoriteBooks(sort: bookSortType)
        
        if searchQuery.isEmpty {
            return sortedBookArray
        } else {
            return sortedBookArray.filter {
                $0.title.contains(searchQuery) || $0.author.contains(searchQuery)
            }
        }
    }
}
