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
    
    private init() { }
    
    static func openLocalRealm() -> Realm {
        let config = Realm.Configuration(
            schemaVersion: 0,
            deleteRealmIfMigrationNeeded: true)
        print("Realm DB 저장소의 위치: \(config.fileURL!)")
        
        return try! Realm(configuration: config)
    }
    
    func deleteFavoriteBook(_ isbn13: String) {
        do {
            let object = realm.objects(FavoriteBook.self).filter("isbn13 == %@", isbn13).first

            try realm.write {
                if let obj = object {
                    realm.delete(obj)
                }
            }
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
            }
    }
}
