//
//  AnalysisHighlightTabView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/14/23.
//

import SwiftUI
import RealmSwift

struct AnalysisHighlightTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(CompleteBook.self) var readingBooks
    
    // MARK: - COMPUTED PROPERTIES
    
    var totalPagesByCategoryChartData: [ChartData.TotalPagesReadByCategory] {
        var totalPagesReadByCategory: [ChartData.TotalPagesReadByCategory] = []
        
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
    
    var totalDailyReadPagesChartData: [ChartData.DailyPagesRead] {
        var dailyPages: [ChartData.DailyPagesRead] = []
        
        for readingBook in readingBooks {
            for record in readingBook.records {
                if let index = dailyPages.firstIndex(where: { $0.date.isEqual([.year, .month, .day], date: record.date) }) {
                    dailyPages[index].pages += record.numOfPagesRead
                } else {
                    dailyPages.append(
                        ChartData.DailyPagesRead(date: record.date, pages: record.numOfPagesRead)
                    )
                }
            }
        }
        
        return dailyPages
    }
    
    var monthlyBooksCompletedChartData: [ChartData.MonthlyCompleteBook] {
        var monthlyCompleteBook: [ChartData.MonthlyCompleteBook] = []
        
        for readingBook in readingBooks {
            if readingBook.isComplete {
                if let index = monthlyCompleteBook.firstIndex(where: { $0.date.isEqual([.year ,.month], date: readingBook.completeDate ?? Date()) } ) {
                    monthlyCompleteBook[index].count += 1
                } else {
                    monthlyCompleteBook.append(
                        ChartData.MonthlyCompleteBook(date: readingBook.completeDate ?? Date(), count: 1)
                    )
                }
            }
        }
        return monthlyCompleteBook
    }
    
    var mainReadingTime: MainReadingTime? {
        guard !readingBooks.isEmpty else {
            return nil
        }
        
        var period = ["dawn": 0, "morning": 0, "lunch": 0, "evening": 0]
        
        var readingDate: [Date] = []
        
        for readingBook in readingBooks {
            for record in readingBook.records {
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
    
    var consecutiveReadingDay: Int? {
        guard !readingBooks.isEmpty else {
            return nil
        }
        
        var readingDate: [Date] = []
        
        for readingBook in readingBooks {
            for record in readingBook.records {
                readingDate.append(record.date)
            }
        }
        
        guard !readingDate.isEmpty else {
            return nil
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
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            highlightHeaderText
            
            highlightCellGroup
        }
    }
}

// MARK: - EXTENSIONS

extension AnalysisHighlightTabView {
    var highlightHeaderText: some View {
        Text("하이라이트")
            .font(.title2.weight(.bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, -2)
    }
    
    var highlightCellGroup: some View {
        VStack {
            HStack {
                mainReadingHourHighlightCell
                
                consecutiveReadingDaysHighlightCell
            }
            
            HStack {
                mainReadingGenreHighlightCell
                
                totalNumberOfBooksReadHighlightCell
            }
        }
    }
    
    var mainReadingHourHighlightCell: some View {
        Group {
            let time = mainReadingTime
            
            HStack {
                if let time {
                    Image(systemName: time.systemImage)
                        .font(.largeTitle)
                        .foregroundColor(time.themeColor)
                    
                    VStack(alignment: .leading) {
                        Text("주 독서 시간대")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                        Text(time.name)
                            .font(.title2.weight(.bold))
                            .foregroundColor(time.themeColor)
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
            .opacity(time == nil ? 0.5 : 1)
        }
    }
    
    var consecutiveReadingDaysHighlightCell: some View {
        Group {
            let days = consecutiveReadingDay
            
            HStack {
                Image(systemName: "calendar.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                
                VStack(alignment: .leading) {
                    Text("연속 독서일")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    if let days {
                        Text("\(days)일")
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
            .opacity(days == nil ? 0.5 : 1)
        }
    }
    
    var mainReadingGenreHighlightCell: some View {
        Group {
            let chartData = totalPagesByCategoryChartData
            
            HStack {
                if !chartData.isEmpty {
                    Image(systemName: "list.bullet.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(chartData[0].category.themeColor)
                } else {
                    Image(systemName: "list.bullet.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                }
                
                VStack(alignment: .leading) {
                    Text("주 독서 분야")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    if !chartData.isEmpty {
                        Text("\(chartData[0].category.name)")
                            .font(.title2.weight(.bold))
                            .foregroundColor(chartData[0].category.themeColor)
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
            .opacity(chartData.isEmpty ? 0.5 : 1)
        }
    }
    
    var totalNumberOfBooksReadHighlightCell: some View {
        Group {
            let chartData = monthlyBooksCompletedChartData
            
            HStack {
                Image(systemName: "books.vertical.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(chartData.isEmpty ? Color.black : Color.blue)
                
                VStack(alignment: .leading) {
                    Text("총 읽은 도서 수")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    if chartData.isEmpty {
                        Text("-")
                            .font(.title2.weight(.bold))
                            .foregroundColor(Color.black)
                    } else {
                        Text("\(chartData.reduce(0, { $0 + $1.count }))권")
                            .font(.title2.weight(.bold))
                            .foregroundColor(Color.blue)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white, in: .rect(cornerRadius: 20))
            .opacity(chartData.isEmpty ? 0.5 : 1)
        }
    }
}

// MARK: - PREVIEW

#Preview {
    AnalysisHighlightTabView()
}
