//
//  ReadingBookRenewalButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct ReadingBookRenewalButtonView: View {
    @ObservedRealmObject var readingBook: ReadingBook
    
    var body: some View {
        HStack {
//            @Persisted var date: Date           // 읽은 날짜
//            @Persisted var totalPagesRead: Int  // 지금까지 읽은 페이지 쪽 수
//            @Persisted var numOfPagesRead: Int  // 그 날에 읽은 페이지 쪽 수
            
            Button {
                let record = ReadingRecords(
                    value: ["date": Date(),
                            "totalPagesRead": 100,
                            "numOfPagesRead": 0
                           ] as [String : Any]
                )
                
                withAnimation {
                    $readingBook.readingRecords.append(record)
                }
            } label: {
                Text("읽었어요!")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 112, height: 30)
                    .background(.gray.opacity(0.3))
                    .clipShape(Capsule())
            }
            
            // 코드 미완성 (오늘 상태 메시지 출력하기)
            Text("오늘 10페이지나 읽었어요!")
                .font(.caption.weight(.light))
                .padding(.horizontal)
            

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .bottom])
    }
}

struct ReadingBookRenewalButtonView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        ReadingBookRenewalButtonView(readingBook: readingBooks[0])
    }
}
