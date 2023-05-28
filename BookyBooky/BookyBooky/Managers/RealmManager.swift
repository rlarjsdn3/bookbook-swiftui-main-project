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
        
    // MARK: - PROPERTIES
    
    lazy var realm = openLocalRealm()
    
    @Published var isPresentingReadingBookAddSuccessToastAlert = false
    @Published var isPresentingReadingBookEditSuccessToastAlert = false
    @Published var isPresentingReadingBookRenewalSuccessToastAlert = false
    @Published var isPresentingFavoriteBookAddSuccessToastAlert = false
    
    // MARK: - FUNCTIONS
    
    func openLocalRealm() -> Realm {
        let config = Realm.Configuration(
            schemaVersion: 0,
            deleteRealmIfMigrationNeeded: true
        )
        print("Realm DB 저장소의 위치: \(config.fileURL!)")
        
        return try! Realm(configuration: config)
    }
}

// MARK: - EXTENSIONS

extension RealmManager {
    
    /// 완독 목표 도서를 추가합니다.
    /// - Parameter object: 추가할 완독 목표 도서 객체
    func addReadingBook(_ object: ReadingBook) {
        try! realm.write {
            realm.add(object)
        }
        self.isPresentingReadingBookAddSuccessToastAlert = true
    }
    
    
    /// 완독 목표 도서를 삭제합니다.
    /// - Parameter object: 삭제할 완독 목표 도서 객체
    func deleteReadingBook(_ object: ReadingBook) {
        guard let object = realm.objects(ReadingBook.self)
            .findReadingBookFirst(with: object.isbn13) else {
            return
        }
        
        try! realm.write {
            realm.delete(object)
        }
    }
    
    /// 읽고 있는 도서의 독서 기록을 추가합니다.
    /// 동일 일자에 여러 번 추가하는 경우, 가장 마지막으로 추가된 독서 기록 데이터로 덮어씌워집니다.
    /// 도서를 완독한 경우, 완독 일자(completeDate)에 오늘 날짜가 추가됩니다.
    /// - Parameters:
    ///   - readingBook: 독서 기록을 추가할 읽고 있는 도서 객체
    ///   - totalPagesRead: 읽은 총 페이지 수
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
                DispatchQueue.global().sync {
                    try! realm.write {
                        object.readingRecords.remove(at: object.readingRecords.endIndex - 1)
                    }
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
                
                // NOTE: - 하나의 코드 블록 안에 두 번의 트랜잭션을 수행한다면, 각각의 트랜잭션이 다른 스레드에서 동시에 수행될 수 있습니다.
                //       - 이는 동시성 문제를 야기할 수 있는 상황입니다. 따라서 DispatchQueue를 활용해 트랜잭션을 동기적으로 수행하도록 해야 합니다.
                //       - 위 코드에서는 마지막 독서 데이터의 삭제 연산을 동기적으로 수행합니다.
                //       - (알 수 없는 이유로 수정 연산을 수행하는 경우, 뷰가 제대로 리-렌더링되지 않습니다. 하는 수 없이 삭제 후 추가 연산으로 구현하였습니다.)
                
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
        // 독서 데이터가 하나 이상 존재하지 않는 경우
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
    
    /// 도서를 완독했는지 검사하는 함수입니다.
    /// - Parameter readingBook: 읽고 있는 도서 객체
    private func checkReadingBookComplete(_ readingBook: ReadingBook) {
        guard let object = realm.objects(ReadingBook.self)
            .filter({ $0.isbn13 == readingBook.isbn13 }).first else {
            return
        }
        
        if object.lastRecord?.totalPagesRead == object.itemPage {
            try! realm.write {
                object.completeDate = Date()
            }
        } else {
            self.isPresentingReadingBookRenewalSuccessToastAlert = true
        }
    }
    
    /// 읽고 있는 도서의 마지막 독서 기록을 삭제합니다.
    /// - Parameter book: 읽고 있는 도서 객체
    func deleteLastRecord(_ readingBook: ReadingBook) {
        if let object = realm.objects(ReadingBook.self)
            .filter({ $0.isbn13 == readingBook.isbn13 }).first {
            try! realm.write {
                object.readingRecords.remove(at: object.readingRecords.endIndex - 1)
            }
        }
    }
    
    
    /// 읽고 있는 도서의 전체 독서 기록을 삭제합니다.
    /// - Parameter book: 읽고 있는 도서 객체
    func deleteAllRecord(_ book: ReadingBook) {
        if let object = realm.objects(ReadingBook.self)
            .filter({ $0.isbn13 == book.isbn13 }).first {
            try! realm.write {
                object.readingRecords.removeAll()
            }
        }
    }
}

extension RealmManager {
    
    /// 찜한 도서를 추가합니다.
    /// - Parameter object: 찜한 도서 객체
    func addFavoriteBook(_ object: FavoriteBook) {
        try! realm.write {
            realm.add(object)
        }
        
        isPresentingFavoriteBookAddSuccessToastAlert = true
    }
    
    /// 찜한 도서를 삭제합니다.
    /// - Parameter isbn13: 찜한 도서의 ISBN13값
    func deleteFavoriteBook(_ isbn13: String) {
        guard let object = realm.objects(FavoriteBook.self)
            .filter( { $0.isbn13 == isbn13 } ).first else {
            return
        }
        
        deleteFavoriteBook(object)
    }
    
    /// 찜한 도서를 삭제합니다.
    /// - Parameter object: 찜한 도서 객체
    func deleteFavoriteBook(_ object: FavoriteBook) {
        try! realm.write {
            realm.delete(object)
        }
    }
}

extension RealmManager {
    func showReadingBookAddSuccessToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "도서 추가 완료")
    }
    
    func showReadingBookEditSuccessToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "도서 편집 완료")
    }
    
    func showReadingBookRenewalSuccessToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "도서 갱신 완료")
    }
    
    func showFavoriteBookAddSuccessToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "찜하기 완료")
    }
    
}
