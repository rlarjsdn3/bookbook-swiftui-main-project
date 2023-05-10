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
    
    @State private var isPresentingRenewalSheet = false
    
    var isValidDate: Bool {
        guard !readingBook.readingRecords.isEmpty else {
            return true
        }
        
        let result = readingBook.readingRecords.last!.date.compare(Date.now)
        
        switch result {
        case .orderedAscending, .orderedSame:
            return true
        case .orderedDescending:
            return false
        }
    }
    
    var body: some View {
        HStack {
            Button {
                isPresentingRenewalSheet = true
            } label: {
                Group {
                    if isValidDate {
                        Text("읽었어요!")
                    } else {
                        Text("갱신 불가")
                            .opacity(0.75)
                    }
                }
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: 112, height: 30)
                .background(.gray.opacity(0.3))
                .clipShape(Capsule())
            }
            .disabled(!isValidDate)
            
            // 코드 미완성 (오늘 상태 메시지 출력하기)
            if isValidDate {
                if let lastRecord = readingBook.readingRecords.last {
                    let calendar = Calendar.current
                    
                    let components1 = calendar.dateComponents([.year, .month, .day], from: lastRecord.date)
                    let components2 = calendar.dateComponents([.year, .month, .day], from: Date.now)
                    
                    if components1.year == components2.year && components1.month == components2.month && components1.day == components2.day {
                        Text("오늘 \(lastRecord.numOfPagesRead)페이지나 읽었어요!")
                            .font(.caption.weight(.light))
                            .padding(.horizontal)
                    } else {
                        Text("독서를 시작해보세요!")
                            .font(.caption.weight(.light))
                            .padding(.horizontal)
                    }
                } else {
                    Text("독서를 시작해보세요!")
                        .font(.caption.weight(.light))
                        .padding(.horizontal)
                }
            } else {
                Text("목표를 다시 설정해주세요!")
                    .font(.caption.weight(.light))
                    .padding(.horizontal)
            }
        }
        .sheet(isPresented: $isPresentingRenewalSheet) {
            ReadingBookRenewalView(readingBook: readingBook)
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
