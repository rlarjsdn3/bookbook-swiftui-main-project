//
//  RealmManager.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/05.
//

import Foundation
import RealmSwift

class RealmManager {
    
    let realm = openLocalRealm()
    
    static let shared = RealmManager()
    
    @ObservedResults(ReadingBook.self) var readingBooks
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    private init() { }
    
    static func openLocalRealm() -> Realm {
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
