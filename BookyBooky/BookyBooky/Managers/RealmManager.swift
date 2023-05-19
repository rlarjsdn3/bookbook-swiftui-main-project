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
    
    // MARK: - TOAST ALERT PROPERTIES
    
    @Published var isPresentingFavoriteBookAddCompleteToastAlert = false
    @Published var isPresentingReadingBookAddCompleteToastAlert = false
    @Published var isPresentingReadingBookEditComleteToastAlert = false
    
    // MARK: - TOAST ALERT FUNCTIONS

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

    // MARK: - FUNCTION
    
    func openLocalRealm() -> Realm {
        let config = Realm.Configuration(
            schemaVersion: 0,
            deleteRealmIfMigrationNeeded: true
        )
        print("Realm DB 저장소의 위치: \(config.fileURL!)")
        
        return try! Realm(configuration: config)
    }

    // MARK: - FAVORITE BOOK CRUD
    
    func addFavoriteBook(_ object: FavoriteBook) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    func deleteFavoriteBook(_ object: FavoriteBook) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func deleteFavoriteBook(_ isbn13: String) {
        if let object = favoriteBooks.filter("isbn13 == %@", isbn13).first {
            deleteFavoriteBook(object)
        }
    }
    
    // MARK: - READING BOOK CRUD
    
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
    
    /// 도서를 완독했는지 검사하는 함수입니다.
    /// 도서를 완독하면 completeDate에 날짜 정보를 추가합니다.
    /// - Parameter readingBook: 읽고 있는 도서 데이터
    func checkReadingBookComplete(_ readingBook: ReadingBook) {
        guard let object = realm.objects(ReadingBook.self)
            .filter({ $0.isbn13 == readingBook.isbn13 }).first else {
            return
        }
        
        if object.lastRecord?.totalPagesRead == object.itemPage {
            try! realm.write {
                object.completeDate = Date()
            }
        }
    }
    
    // MARK: - READING RECORDS CRUD
    
    func addReadingBookRecord(_ readingBook: ReadingBook, totalPagesRead: Int) {
        guard let object = realm.objects(ReadingBook.self)
            .findReadingBookFirst(with: readingBook.isbn13) else {
            return
        }
        
        var readingRecord: ReadingRecord
        
        // 독서 데이터가 하나 이상 존재하는 경우
        if let lastRecord = object.lastRecord {
            // 오늘 날짜와 마지막 독서 데이터의 날짜가 동일한 경우
            if Date().isEqual([.year, .month, .day], date: lastRecord.date) {
                // 독서 데이터 삭제하기
                try! realm.write {
                    let localObject = object
                    localObject.readingRecords.remove(at: object.readingRecords.endIndex - 1)
                }
                
                if object.readingRecords.isEmpty {
                    readingRecord = ReadingRecord(
                        value: ["date": Date(),
                                "totalPagesRead": totalPagesRead,
                                "numOfPagesRead": totalPagesRead
                               ] as [String : Any]
                    )
                } else {
                    readingRecord = ReadingRecord(
                        value: ["date": Date(),
                                "totalPagesRead": totalPagesRead,
                                "numOfPagesRead": totalPagesRead - lastRecord.totalPagesRead
                               ] as [String : Any]
                    )
                }
                
                // 독서 데이터 추가하기
                try! realm.write {
                    object.readingRecords.append(readingRecord)
                }
            // 오늘 날짜와 마지막 독서 데이터의 날짜가 동일하지 않은 경우
            } else {
                readingRecord = ReadingRecord(
                    value: ["date": Date(),
                            "totalPagesRead": totalPagesRead,
                            "numOfPagesRead": totalPagesRead - lastRecord.totalPagesRead
                           ] as [String : Any]
                )
                // 독서 데이터 추가하기
                try! realm.write {
                    object.readingRecords.append(readingRecord)
                }
            }
        } else {
            readingRecord = ReadingRecord(
                value: ["date": Date(),
                        "totalPagesRead": totalPagesRead,
                        "numOfPagesRead": totalPagesRead
                       ] as [String : Any]
            )
            // 독서 데이터 추가하기
            try! realm.write {
                object.readingRecords.append(readingRecord)
            }
        }
        
        checkReadingBookComplete(object)
    }
    
    func deleteLastRecord(_ book: ReadingBook) {
        if let object = realm.objects(ReadingBook.self)
            .filter({ $0.isbn13 == book.isbn13 }).first {
            try! realm.write {
                object.readingRecords.remove(at: object.readingRecords.endIndex - 1)
            }
        }
    }
    
    func deleteAllRecord(_ book: ReadingBook) {
        if let object = realm.objects(ReadingBook.self)
            .filter({ $0.isbn13 == book.isbn13 }).first {
            try! realm.write {
                object.readingRecords.removeAll()
            }
        }
    }
    
    // MARK: -
}

// MARK: - EXTENSIONS

extension RealmManager {
    
    
}
