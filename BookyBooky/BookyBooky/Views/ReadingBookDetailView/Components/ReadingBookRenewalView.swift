//
//  ReadingBookRenewalView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/05.
//

import SwiftUI
import Foundation
import RealmSwift

struct ReadingBookRenewalView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var page = 0
    
    var lastReadingPage: Int {
        if let record = readingBook.readingRecords.last {
            return record.totalPagesRead
        } else {
            return 0
        }
    }
    
    var themeColor: Color {
        readingBook.category.accentColor
    }
    
    var body: some View {
        VStack {
            Text("어디까지 읽으셨나요?")
                .font(.title.weight(.bold))
                .offset(y: 45)
            
            Spacer()
        
            VStack {
                Text("\(page)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .padding(.vertical, 2)
                
                Text("페이지")
                    .font(.title3.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .overlay {
                HStack {
                    Button {
                        page -= 1
                    } label: {
                        Image(systemName: "minus")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(.vertical, 23)
                            .padding(.horizontal)
                            .background(themeColor)
                            .clipShape(Circle())
                    }
                    .opacity(lastReadingPage >= page ? 0.5 : 1)
                    .disabled(lastReadingPage >= page ? true : false)
                    
                    Spacer()
                    
                    Button {
                        page += 1
                    } label: {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(themeColor)
                            .clipShape(Circle())
                    }
                    .opacity(readingBook.itemPage <= page ? 0.5 : 1)
                    .disabled(readingBook.itemPage <= page ? true : false)
                }
                .offset(y: -17)
                .padding()
            }
            .padding()
            
            Spacer()
            
            Button {
                let calendar = Calendar.current
                
//                @Persisted var date: Date           // 읽은 날짜
//                @Persisted var totalPagesRead: Int  // 지금까지 읽은 페이지 쪽 수
//                @Persisted var numOfPagesRead: Int  // 그 날에 읽은 페이지 쪽 수
                
                
                if let lastRecord = readingBook.readingRecords.last {

                    let components1 = calendar.dateComponents([.year, .month, .day], from: lastRecord.date)
                    let components2 = calendar.dateComponents([.year, .month, .day], from: Date.now)
                    
                    if (components1.year == components2.year) &&
                       (components1.month == components2.month) &&
                       (components1.day == components2.day) {
                        
                        $readingBook.readingRecords.remove(at: readingBook.readingRecords.endIndex - 1)
                        
                        var records: ReadingRecords
                        
                        if let last = readingBook.readingRecords.last {
                            records = ReadingRecords(
                                value: ["date": Date.now,
                                        "totalPagesRead": page,
                                        "numOfPagesRead": page - last.totalPagesRead
                                       ] as [String: Any]
                            )
                        } else {
                            records = ReadingRecords(
                                value: ["date": Date.now,
                                        "totalPagesRead": page,
                                        "numOfPagesRead": page
                                       ] as [String: Any]
                            )
                        }
                        
                        $readingBook.readingRecords.append(records)
                        
                    } else {
                        
                        let records = ReadingRecords(
                            value: ["date": Date.now,
                                    "totalPagesRead": page,
                                    "numOfPagesRead": page - lastRecord.totalPagesRead
                                   ] as [String: Any]
                        )
                        $readingBook.readingRecords.append(records)
                    }
                    
                } else {
                    
                    let records = ReadingRecords(
                        value: ["date": Date.now,
                                "totalPagesRead": page,
                                "numOfPagesRead": page
                               ] as [String: Any]
                    )
                    
                    $readingBook.readingRecords.append(records)
                }
                
                dismiss()
            } label: {
                Text("갱신하기")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(15)
            }
            .padding(.horizontal)
            
        }
        .onAppear {
            if let record = readingBook.readingRecords.last {
                page = record.totalPagesRead
            } else {
                page = 0
            }
        }
        .presentationCornerRadius(30)
        .presentationDetents([.height(400)])
    }
}

struct ReadingBookRenewalView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        ReadingBookRenewalView(readingBook: readingBooks[0])
    }
}
