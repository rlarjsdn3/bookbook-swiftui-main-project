//
//  AnalysisScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/14/23.
//

import SwiftUI
import Charts
import RealmSwift

struct AnalysisScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    @State private var startOffset: CGFloat = 0.0
    
    // MARK: - PROPERTIES
    
    @Binding var scrollYOffset: CGFloat
    
    
    
    
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
    
    var dailyPages: [DailyPagesRead] {
        var dailyPages: [DailyPagesRead] = []
        
        for readingBook in readingBooks {
            for record in readingBook.readingRecords {
                if let index = dailyPages.firstIndex(where: { $0.date.isEqual([.year, .month, .day], date: record.date) }) {
                    dailyPages[index].pages += record.numOfPagesRead
                } else {
                    dailyPages.append(
                        DailyPagesRead(date: record.date, pages: record.numOfPagesRead)
                    )
                }
            }
        }
        
        return dailyPages
    }
    
    var monthlyPages: [DailyPagesRead] {
        var monthlyPages: [DailyPagesRead] = []
        
        for readingBook in readingBooks {
            for record in readingBook.readingRecords {
                if let index = monthlyPages.firstIndex(where: { $0.date.isEqual([.year, .month], date: record.date) }) {
                    monthlyPages[index].pages += record.numOfPagesRead
                } else {
                    monthlyPages.append(
                        DailyPagesRead(date: record.date, pages: record.numOfPagesRead)
                    )
                }
            }
        }
        
        return monthlyPages
    }
    
    
    // MARK: - BODY
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    summaryHeaderText
                    
                    totalPagesReadByCategoryChartCellButton
                    
                    totalDailyPagesReadChartCellButton
                    
                    // NOTE: - 해당 기능은 버전 1.1에 언락될 예정입니다.
                    // totalNumberOfBooksReadPerMonthChartCellButton
                }
                
                
                VStack {
                    highlightHeaderText
                    
                    highlightCells
                }
            }
            .overlay(alignment: .top) {
                GeometryReader { proxy -> Color in
                    DispatchQueue.main.async {
                        let offset = proxy.frame(in: .global).minY
                        if startOffset == 0 {
                            self.startOffset = offset
                        }
                        withAnimation(.easeInOut(duration: 0.1)) {
                            scrollYOffset = startOffset - offset
                        }
                        
                        print(scrollYOffset)
                    }
                    return Color.clear
                }
                .frame(width: 0, height: 0)
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaPadding([.leading, .top, .trailing])
        .safeAreaPadding(.bottom, 40)
        .background(Color(.background))
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

extension AnalysisScrollView {
    var summaryHeaderText: some View {
        Text("요약")
            .font(.title2.weight(.bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, -2)
    }
    
    var totalPagesReadByCategoryChartCellButton: some View {
        NavigationLink {
            TotalPagesReadByCategoryChartView(data: totalPagesByCategory)
        } label: {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Label("분류 별 읽은 총 페이지", systemImage: "book")
                        .font(.headline)
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                    
                    Group {
                        Text("자세히 보기")
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                }
                
                if totalPagesByCategory.isEmpty {
                    VStack(spacing: 3) {
                        Text("차트를 표시할 수 없음")
                            .font(.headline)
                        
                        Text("독서를 시작해보세요.")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)
                    }
                    .padding()
                } else {
                    Chart(totalPagesByCategory, id: \.self) { element in
                        BarMark(
                            x: .value("pages", element.pages),
                            stacking: .normalized
                        )
                        .foregroundStyle(by: .value("category", element.category.rawValue))
                    }
                    .frame(height: 50)
                    .padding(5)
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 10)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 10))
        }
        .disabled(totalPagesByCategory.isEmpty ? true : false)
        .buttonStyle(.plain)
    }
    
    var totalDailyPagesReadChartCellButton: some View {
        NavigationLink {
            DailyPagesReadChartView(daily: dailyPages, monthly: monthlyPages)
        } label: {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Label("일일 독서 페이지", systemImage: "book")
                        .font(.headline)
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                    
                    Group {
                        Text("자세히 보기")
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                }
                
                if totalPagesByCategory.isEmpty {
                    VStack(spacing: 3) {
                        Text("차트를 표시할 수 없음")
                            .font(.headline)
                        
                        Text("독서를 시작해보세요.")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)
                    }
                    .padding()
                } else {
                    Chart(dailyPages, id: \.self) { element in
                        BarMark(
                            x: .value("date", element.date, unit: .day),
                            y: .value("pages", element.pages)
                        )
                        .cornerRadius(5.0)
                        .foregroundStyle(element.date.isEqual([.year, .month, .day], date: Date()) ? Color.orange : Color.gray)
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .chartXScale(
                        domain: Date().addingTimeInterval(-14*86400)...Date(),
                        range: .plotDimension(startPadding: 10, endPadding: 10)
                    )
                    .frame(height: 50)
                    .padding(5)
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 10)
            .background(Color.white, in: .rect(cornerRadius: 10))
        }
        .disabled(totalPagesByCategory.isEmpty ? true : false)
        .buttonStyle(.plain)
    }
    
    var totalNumberOfBooksReadPerMonthChartCellButton: some View {
        NavigationLink {
            monthlyCompleteBookChartView(getMonthlyCompleteBook() ?? [])
        } label: {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Label("월별 읽은 도서 수", systemImage: "book")
                        .font(.headline)
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                    
                    Group {
                        Text("자세히 보기")
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                }
                
                if let completeBookCount = getMonthlyCompleteBook() {
                    Chart(completeBookCount, id: \.self) { element in
                        BarMark(
                            x: .value("date", element.date, unit: .month),
                            y: .value("pages", element.count)
                        )
                        .cornerRadius(5.0)
                        .foregroundStyle(element.date.isEqual([.year, .month], date: Date()) ? Color.blue : Color.gray)
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .chartXScale(
                        domain: Date().addingTimeInterval(-30*86400*12)...Date(),
                        range: .plotDimension(startPadding: 10, endPadding: 10)
                    )
                    .frame(height: 50)
                    .padding(5)
                } else {
                    VStack(spacing: 3) {
                        Text("차트를 표시할 수 없음")
                            .font(.headline)
                        
                        Text("독서를 시작해보세요.")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)
                    }
                    .padding()
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 10)
            .background(Color.white, in: .rect(cornerRadius: 10))
        }
        .disabled(getMonthlyCompleteBook() == nil ? true : false)
        .buttonStyle(.plain)
        .padding(.bottom)
    }
    
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
}

#Preview {
    AnalysisScrollView(scrollYOffset: .constant(0.0))
}
