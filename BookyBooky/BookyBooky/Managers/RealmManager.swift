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
    
    let targetBookAddCompleteToastAlert = AlertToast(displayMode: .alert, type: .complete(Color.green), title: "도서 추가 완료")
    let targetBookEditCompleteToastAlert = AlertToast(displayMode: .alert, type: .complete(Color.green), title: "도서 편집 완료")
    
    func favoriteBookAddCompleteToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "찜하기 완료")
    }
        
    // MARK: - PROPERTIES
    
    lazy var realm = openLocalRealm()
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(ReadingBook.self) var readingBooks
    @ObservedResults(FavoriteBook.self) var favoriteBooks

    // MARK: - 
    
    func openLocalRealm() -> Realm {
        let config = Realm.Configuration(
            schemaVersion: 0,
            deleteRealmIfMigrationNeeded: true)
        print("Realm DB 저장소의 위치: \(config.fileURL!)")
        
        return try! Realm(configuration: config)
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
