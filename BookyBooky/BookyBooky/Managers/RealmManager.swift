//
//  RealmManager.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/05.
//

import SwiftUI
import RealmSwift
import AlertToast

class RealmManager: ObservableObject {
    
    // MARK: - ALERT PROPERTIES
    
    @Published var isPresentingFavoriteBookAddCompleteToastAlert = false
    @Published var isPresentingTargetBookAddCompleteToastAlert = false
    @Published var isPresentingTargetBookEditComleteToastAlert = false
    
    // MARK: - ALERT FUNCTIONS

    func showTargetBookAddCompleteToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "도서 추가 완료")
    }
    
    func showTargetBookEditCompleteToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "도서 편집 완료")
    }
    
    func showFavoriteBookAddCompleteToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "찜하기 완료")
    }
        
    // MARK: - REALM PROPERTIES
    
    lazy var realm = openLocalRealm()
    
    @ObservedResults(ReadingBook.self) var readingBooks
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    // MARK: - COMPUTED PROPERTIES
    
    var completeBooks: [ReadingBook] {
        readingBooks.filter { $0.isComplete }
    }

    // MARK: - FUNCTION
    
    func openLocalRealm() -> Realm {
        let config = Realm.Configuration(
            schemaVersion: 0,
            deleteRealmIfMigrationNeeded: true)
        print("Realm DB 저장소의 위치: \(config.fileURL!)")
        
        return try! Realm(configuration: config)
    }
    
    enum readingBookType {
        case all
        case complete
        case unfinished
    }
    
    /// 읽고 있거나 읽은 도서 배열을 반환하는 함수입니다.
    ///
    ///  isComplete 매개변수의 기본 값은 false이며, 완독하지 않은 도서 배열을 반환합니다. isComplete 매개변수를 true로 주어지면 완독한 도서 배열을 반환합니다.
    ///  isComplete: true → 완독한 도서 배열 반환
    ///  isComplete: false → 완독하지 않은 도서 배열 반환
    ///
    /// - Parameter isComplete: 완독 유무에 따른 반환할 ReadingBook 형의 배열을 결정하는 불(Bool) 형 값
    /// - Returns: ReadingBook 형의 배열
    func getReadingBooks(_ type: readingBookType) -> [ReadingBook] {
        let readingBooks = realm.objects(ReadingBook.self)
        
        switch type {
        case .all:
            return Array(readingBooks)
        case .complete:
            return readingBooks.filter { $0.isComplete }
        case .unfinished:
            return readingBooks.filter { !$0.isComplete }
        }
    }
    
    func getReadingBookCategoryType() -> [CategoryTypes] {
        var categoryTypes: [CategoryTypes] = [.all]
        
        for book in readingBooks where !categoryTypes.contains(book.category) && !book.isComplete {
            categoryTypes.append(book.category)
        }
        
        return categoryTypes
    }
    
    /// 매개변수로 주어진 도서의 ISBN13과 동일한 값을 가지는 객체를 반환하는 함수입니다. 해당하는 객체가 존재하지 않는다면 nil을 반환합니다.
    /// - Parameter isbn13: 찾고자 하는 도서의 ISBN13
    /// - Returns: Book 프로토콜을 준수하는 Obect 객체
    func findReadingBookFirst(with isbn13: String) -> ReadingBook? {
        if let book = readingBooks.first(where: { $0.isbn13 == isbn13 }) {
            return book
        }
        return nil
    }
    
    ///  첫번째 매개변수로 주어진 ReadingBooks 도서 배열을 sortType 매개변수로 주어진 기준에 맞추어 정렬된 배열을 반환하는 함수입니다.
    /// - Parameters:
    ///   - sortType: 정렬 기준
    /// - Returns: 정렬된 Book 프로토콜을 준수하는 도서 배열
    private func sortReadingBookArray(sortType: BookSortCriteriaType) -> [ReadingBook] {
        switch sortType {
        case .latestOrder:
            return readingBooks.reversed()
        case .titleOrder:
            return readingBooks.sorted { $0.title > $1.title }
        case .authorOrder:
            return readingBooks.sorted { $0.author > $1.author }
        }
    }
    
    ///  ReadingBook 형의 배열을 bookSort 매개변수로 주어진 기준으로 정렬하고, 정렬한 배열을 categoryType 매개변수로 주어진 기준으로 필터링한 배열을 반환하는 함수입니다.
    /// - Parameters:
    ///   - bookSortType: 도서 정렬 기준
    ///   - categoryType: 도서 필터 기준 (카테고리 별)
    /// - Returns: 정렬 및 필터링된 ReadingBook 형의 배열
    func filterReadingBookArray(bookSortType: BookSortCriteriaType, categoryType: CategoryTypes) -> [ReadingBook] {
        let sortedBookArray = sortReadingBookArray(sortType: bookSortType)
        
        if categoryType == .all {
            return sortedBookArray.filter { !$0.isComplete }
        } else {
            return sortedBookArray.filter { categoryType == $0.category && !$0.isComplete }
        }
    }
    
    
    /// 최근 3개의 활동 데이터를 반환하는 함수입니다.
    /// - Returns: Activity 형의 배열
    func getRecentReadingActivity() -> [Activity] {
        var activities: [Activity] = []
        
        for readingBook in readingBooks {
            for record in readingBook.readingRecords {
                activities.append(
                    Activity(
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
        
        return Array(activities.sorted { $0.date > $1.date }.prefix(min(activities.count, 3)))
    }
    
    struct MonthlyActivity: Hashable {
        var month: Date
        var activity: [Activity]
    }
    
    func getMonthlyReadingActivity() -> [MonthlyActivity] {
        var monthlyActivity: [MonthlyActivity] = []
        let readingBooks = getReadingBooks(.all)
        
        readingBooks.forEach { readingBook in
            readingBook.readingRecords.forEach { record in
                if let index = monthlyActivity.firstIndex(where: {
                    $0.month.isEqual([.year, .month], date: record.date)
                }) {
                    monthlyActivity[index].activity.append(
                        Activity(date: record.date, title: readingBook.title, category: readingBook.category, itemPage: readingBook.itemPage, isbn13: readingBook.isbn13, numOfPagesRead: record.numOfPagesRead, totalPagesRead: record.totalPagesRead)
                    )
                } else {
                    monthlyActivity.append(
                        MonthlyActivity(
                            month: record.date,
                            activity: [
                                Activity(date: record.date, title: readingBook.title, category: readingBook.category, itemPage: readingBook.itemPage, isbn13: readingBook.isbn13, numOfPagesRead: record.numOfPagesRead, totalPagesRead: record.totalPagesRead)
                            ]
                        )
                    )
                }
            }
        }
        
        monthlyActivity.sort { $0.month > $1.month }
        
        return monthlyActivity
    }
    
    func activitiesCount(_ activity: MonthlyActivity) -> Int {
        var dates: [Date] = []
        
        activity.activity.forEach { act in
            if !dates.contains(where: { $0.isEqual([.year, .month, .day], date: act.date) }) {
                dates.append(act.date)
            }
        }
        return dates.count
    }
    
    // MARK: - FAVORITE BOOK
    
    func addFavoriteBook(_ object: FavoriteBook) {
        $favoriteBooks.append(object)
    }
    
    func deleteFavoriteBook(_ object: FavoriteBook) {
        $favoriteBooks.remove(object)
    }
    
    func deleteFavoriteBook(_ isbn13: String) {
        if let object = favoriteBooks.filter("isbn13 == %@", isbn13).first {
            deleteFavoriteBook(object)
        }
    }
    
    // MARK: - READING BOOK
    
    func addReadingBook(_ object: ReadingBook) {
        $readingBooks.append(object)
    }
    
    func deleteReadingBook(_ isbn13: String) {
        if let object = readingBooks.filter("isbn13 == %@", isbn13).first {
            deleteReadingBook(object)
        }
    }
    
    func deleteReadingBook(_ object: ReadingBook) {
        $readingBooks.remove(object)
    }
    
    // MARK: - READING RECORDS
    
}
