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
    
    static func openLocalRealm() -> Realm? {
        do {
            let config = Realm.Configuration(
                schemaVersion: 0,
                deleteRealmIfMigrationNeeded: true)
            print("Realm DB 저장소의 위치: \(config.fileURL!)")
            
            return try Realm(configuration: config)
        } catch {
            print("Realm DB 초기화 예외: \(error)")
        }
        
        return nil
    }
}
