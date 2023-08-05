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
    
    lazy var realm: Realm! = openLocalRealm()
    
    // MARK: - FUNCTIONS
    
    func openLocalRealm() -> Realm? {
        let config = Realm.Configuration(
            schemaVersion: 0,
            deleteRealmIfMigrationNeeded: true
        )
        print("Realm DB 저장소의 위치: \(config.fileURL!)")
        
        return try? Realm(configuration: config)
    }
}

// MARK: - EXTENSIONS

extension RealmManager {
    
    /// 완독 목표 도서를 추가합니다.
    /// - Parameter object: 추가할 완독 목표 도서 객체
    func addReadingBook(_ object: CompleteBook) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    
    /// 완독 목표 도서를 삭제합니다.
    /// - Parameter object: 삭제할 완독 목표 도서 객체
    func deleteReadingBook(_ object: CompleteBook) {
        guard let object = realm.objects(CompleteBook.self)
            .firstObject(isbn13: object.isbn13) else {
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
    func addReadingBookRecord(_ readingBook: CompleteBook, totalPagesRead: Int) {
        guard let object = realm.objects(CompleteBook.self)
            .firstObject(isbn13: readingBook.isbn13) else {
            return
        }
        
        // 독서 데이터가 하나 이상 존재하는 경우
        if let lastRecord = object.lastRecord {
            // 오늘 날짜와 마지막 독서 데이터의 날짜가 동일한 경우
            if Date().isEqual([.year, .month, .day], with: lastRecord.date) {
                if object.records.count <= 1 {
                    try! realm.write {
                        object.records.last?.date = Date()
                        object.records.last?.totalPagesRead = totalPagesRead
                        object.records.last?.numOfPagesRead = totalPagesRead
                    }
                } else {
                    try! realm.write {
                        object.records.last?.date = Date()
                        object.records.last?.totalPagesRead = totalPagesRead
                        object.records.last?.numOfPagesRead = totalPagesRead - readingBook.records[readingBook.records.endIndex - 2].totalPagesRead
                    }
                }                
            // 오늘 날짜와 마지막 독서 데이터의 날짜가 동일하지 않은 경우
            } else {
                let readingRecord = Record(
                    value: ["date": Date(),
                            "totalPagesRead": totalPagesRead,
                            "numOfPagesRead": totalPagesRead - lastRecord.totalPagesRead
                           ] as [String : Any]
                )
                // 독서 데이터 추가하기
                try! realm.write {
                    object.records.append(readingRecord)
                }
            }
        // 독서 데이터가 하나 이상 존재하지 않는 경우
        } else {
            let readingRecord = Record(
                value: ["date": Date(),
                        "totalPagesRead": totalPagesRead,
                        "numOfPagesRead": totalPagesRead
                       ] as [String : Any]
            )
            // 독서 데이터 추가하기
            try! realm.write {
                object.records.append(readingRecord)
            }
        }
        
        checkReadingBookComplete(object)
    }
    
    /// 도서를 완독했는지 검사하는 함수입니다.
    /// - Parameter readingBook: 읽고 있는 도서 객체
    private func checkReadingBookComplete(_ readingBook: CompleteBook) {
        guard let object = realm.objects(CompleteBook.self)
            .firstObject(isbn13: readingBook.isbn13) else {
            return
        }
        
        if object.lastRecord?.totalPagesRead == object.itemPage {
            try! realm.write {
                object.completeDate = Date()
            }
        }
    }
    
    /// 읽고 있는 도서의 마지막 독서 기록을 삭제합니다.
    /// - Parameter book: 읽고 있는 도서 객체
    func deleteLastRecord(_ readingBook: CompleteBook) {
        if let object = realm.objects(CompleteBook.self)
            .filter({ $0.isbn13 == readingBook.isbn13 }).first {
            try! realm.write {
                object.records.remove(at: object.records.endIndex - 1)
            }
        }
    }
    
    
    /// 읽고 있는 도서의 전체 독서 기록을 삭제합니다.
    /// - Parameter book: 읽고 있는 도서 객체
    func deleteAllRecord(_ book: CompleteBook) {
        if let object = realm.objects(CompleteBook.self)
            .filter({ $0.isbn13 == book.isbn13 }).first {
            try! realm.write {
                object.records.removeAll()
            }
        }
    }
    
    func editReadingBook(_ book: CompleteBook, title: String, publisher: String, category: Category, targetDate: Date) {
        guard let object = realm.object(ofType: CompleteBook.self, forPrimaryKey: book._id) else { return }
          
        try! realm.write {
            object.title = title
            object.publisher = publisher
            object.category = category
            object.targetDate = targetDate
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
    func addSentence(_ readingBook: CompleteBook, sentence: String, page: Int) {
        guard let object = realm.objects(CompleteBook.self)
            .firstObject(isbn13: readingBook.isbn13) else {
            return
        }
        
        let sentence = Sentence(
            value: ["date": Date(),
                    "page": page,
                    "sentence": sentence] as [String: Any]
        )
        
        try! realm.write {
            object.sentences.append(sentence)
        }
    }
    
    func modifySentence(_ readingBook: CompleteBook, id: ObjectId, sentence: String, page: Int) {
        guard let object = realm.objects(CompleteBook.self)
            .firstObject(isbn13: readingBook.isbn13) else {
            return
        }
        
        guard let index = readingBook.sentences
            .firstIndex(where: { $0._id == id }) else {
            return
        }
        
        try! realm.write {
            object.sentences[index].date = Date()
            object.sentences[index].sentence = sentence
            object.sentences[index].page = page
        }
    }
    
    func deleteSentence(_ readingBook: CompleteBook, id: ObjectId) {
        guard let object = realm.objects(CompleteBook.self)
            .firstObject(isbn13: readingBook.isbn13) else {
            return
        }
        
        guard let index = readingBook.sentences
            .firstIndex(where: { $0._id == id }) else {
            return
        }
        
        try! realm.write {
            object.sentences.remove(at: index)
        }
    }
}
