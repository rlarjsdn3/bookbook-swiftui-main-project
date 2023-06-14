//
//  AnalysisHighlightTabView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/14/23.
//

import SwiftUI
import RealmSwift

struct AnalysisHighlightTabView: View {
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    
    
    var totalPagesByCategory: [TotalPagesReadByCategory] {
        var totalPagesReadByCategory: [TotalPagesReadByCategory] = []
        
        for readingBook in readingBooks {
            if let index = totalPagesReadByCategory.firstIndex(where: { $0.category == readingBook.category }) {
                totalPagesReadByCategory[index].pages += readingBook.lastRecord?.totalPagesRead ?? 0
            } else {
                if let last = readingBook.lastRecord {
                    totalPagesReadByCategory.append(
                        .init(category: readingBook.category, pages: last.totalPagesRead)
                    )
                }
            }
        }
        
        return totalPagesReadByCategory.sorted { $0.pages > $1.pages }
    }
    
    
    
    var body: some View {
        VStack {
            highlightHeaderText
            
            highlightCells
        }
    }
    
    func getMonthlyCompleteBook() -> [MonthlyCompleteBook]? {
        var monthlyCompleteBook: [MonthlyCompleteBook] = []
        
        for readingBook in readingBooks {
            if readingBook.isComplete {
                if let index = monthlyCompleteBook.firstIndex(where: { $0.date.isEqual([.year ,.month], date: readingBook.completeDate ?? Date()) } ) {
                    monthlyCompleteBook[index].count += 1
                } else {
                    monthlyCompleteBook.append(
                        MonthlyCompleteBook(date: readingBook.completeDate ?? Date(), count: 1)
                    )
                }
            }
        }
        
        if monthlyCompleteBook.isEmpty {
            return nil
        }
        return monthlyCompleteBook
    }
}

extension AnalysisHighlightTabView {
    var highlightHeaderText: some View {
        Text("하이라이트")
            .font(.title2.weight(.bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, -2)
    }
    
    var highlightCells: some View {
        VStack {
            HStack {
                mainReadingHourHighlight
                
                consecutiveReadingDaysHighlight
            }
            
            HStack {
                mainReadingGenreHighlight
                
                totalNumberOfBooksReadHighlight
            }
        }
    }
    
    var mainReadingHourHighlight: some View {
        HStack {
            if let majorPeriod = getMajorReadingPeriod() {
                Image(systemName: majorPeriod.systemImage)
                    .font(.largeTitle)
                    .foregroundColor(majorPeriod.accentColor)
                
                VStack(alignment: .leading) {
                    Text("주 독서 시간대")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    Text(majorPeriod.name)
                        .font(.title2.weight(.bold))
                        .foregroundColor(majorPeriod.accentColor)
                }
            } else {
                Image(systemName: "sunrise.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                
                VStack(alignment: .leading) {
                    Text("주 독서 시간대")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    Text("-")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color.black)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white, in: .rect(cornerRadius: 20))
        .opacity(getMajorReadingPeriod() == nil ? 0.5 : 1)
    }
    
    var consecutiveReadingDaysHighlight: some View {
        HStack {
            Image(systemName: "calendar.circle.fill")
                .font(.largeTitle)
                .foregroundColor(Color.black)
            
            VStack(alignment: .leading) {
                Text("연속 독서일")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                if let consecutiveDays = getConsecutiveReadingDays() {
                    Text("\(consecutiveDays)일")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color.black)
                } else {
                    Text("-")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color.black)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white, in: .rect(cornerRadius: 20))
        .opacity(getConsecutiveReadingDays() == nil ? 0.5 : 1)
    }
    
    var mainReadingGenreHighlight: some View {
        HStack {
            if !totalPagesByCategory.isEmpty {
                Image(systemName: "list.bullet.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(totalPagesByCategory[0].category.accentColor)
            } else {
                Image(systemName: "list.bullet.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
            }
            
            VStack(alignment: .leading) {
                Text("주 독서 분야")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                if !totalPagesByCategory.isEmpty {
                    Text("\(totalPagesByCategory[0].category.rawValue)")
                        .font(.title2.weight(.bold))
                        .foregroundColor(totalPagesByCategory[0].category.accentColor)
                        .lineLimit(1)
                } else {
                    Text("-")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white, in: .rect(cornerRadius: 20))
        .opacity(totalPagesByCategory.isEmpty ? 0.5 : 1)
    }
    
    var totalNumberOfBooksReadHighlight: some View {
        HStack {
            Image(systemName: "books.vertical.circle.fill")
                .font(.largeTitle)
                .foregroundColor(getMonthlyCompleteBook() != nil ? Color.blue : Color.black)
            
            VStack(alignment: .leading) {
                Text("총 읽은 도서 수")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                if let completeBooksCount = getMonthlyCompleteBook() {
                    Text("\(completeBooksCount.reduce(0, { $0 + $1.count }))권")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color.blue)
                } else {
                    Text("-")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color.black)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white, in: .rect(cornerRadius: 20))
        .opacity(getMonthlyCompleteBook() == nil ? 0.5 : 1)
    }
    
    func getMajorReadingPeriod() -> MajorReadingPeriodItems? {
        guard !readingBooks.isEmpty else {
            return nil
        }
        
        var period = ["dawn": 0, "morning": 0, "lunch": 0, "evening": 0]
        
        var readingDate: [Date] = []
        
        for readingBook in readingBooks {
            for record in readingBook.readingRecords {
                readingDate.append(record.date)
            }
        }
        
        for records in readingDate {
            let calendar = Calendar.current
            let hour = calendar.dateComponents([.hour], from: records).hour!
            
            switch hour {
            case _ where 0 <= hour && hour <= 6:
                period["dawn"]? += 1
            case _ where 6 < hour && hour <= 12:
                period["morning"]? += 1
            case _ where 12 < hour && hour <= 18:
                period["lunch"]? += 1
            case _ where 18 < hour && hour <= 24:
                period["evening"]? += 1
            default:
                break
            }
        }
        
        let maxPeriod = Array(period).sorted(by: { $0.key < $1.key }).max(by: { $0.value < $1.value })!
        
        switch maxPeriod.key {
        case "dawn":
            return .dawn
        case "morning":
            return .morning
        case "lunch":
            return .lunch
        case "evening":
            return .evening
        default:
            return .morning
        }
    }
    
    func getConsecutiveReadingDays() -> Int? {
        guard !readingBooks.isEmpty else {
            return nil
        }
        
        var readingDate: [Date] = []
        
        for readingBook in readingBooks {
            for record in readingBook.readingRecords {
                readingDate.append(record.date)
            }
        }
        
        readingDate.sort(by: { $0 < $1 })
        
        var maxConsecutiveDays = 1
        var currentConsecutiveDays = 1
        
        for i in 1..<readingDate.count {
            let calendar = Calendar.current
            let previousDate = calendar.date(
                byAdding: .day,
                value: -1,
                to: readingDate[i]
            )!
            
            if (previousDate.standardDateFormat
                    == readingDate[i-1].standardDateFormat) {
                currentConsecutiveDays += 1
            } else {
                maxConsecutiveDays = max(currentConsecutiveDays, maxConsecutiveDays)
                currentConsecutiveDays = 1
            }
        }
        
        return max(currentConsecutiveDays, maxConsecutiveDays)
    }
}

#Preview {
    AnalysisHighlightTabView()
}
