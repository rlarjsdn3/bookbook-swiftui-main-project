//
//  HomeTargetBookDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct HomeTargetBookDetailView: View {
    @ObservedRealmObject var targetBook: CompleteTargetBook
    
    var body: some View {
        Text("\(targetBook.title)")
            .toolbar(.hidden, for: .navigationBar)
        
        // 테스트 코드
        
        // 일대다 관계가 아니라 포함 관계로 오브젝트를 다시 재정의할 필요가 있음!
        Button("10페이지 읽었음!") {
            let readingRecord = ReadingRecords(
                value: ["date": Date(),
                        "totalPagesRead": 10,
                        "numOfPagesRead": 10] as [String : Any]
            )

            $targetBook.readingRecords.append(readingRecord)
        }
    }
//
//    @Persisted var date: String         // 읽은 날짜
//    @Persisted var totalPagesRead: Int  // 지금까지 읽은 페이지 쪽 수
//    @Persisted var numOfPagesRead: Int  // 그 날에 읽은 페이지 쪽 수
}

struct HomeTargetBookDetailView_Previews: PreviewProvider {
    static let realmManager = RealmManager.openLocalRealm()
    @ObservedResults(CompleteTargetBook.self) static var completeTargetBooks
    
    static var previews: some View {
        HomeTargetBookDetailView(targetBook: completeTargetBooks[0])
    }
}
