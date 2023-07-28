//
//  ReadingBookRecordsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import Charts
import RealmSwift

struct CompleteBookAnalysisView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedRealmObject var completeBook: CompleteBook
    
    @State private var scrollPosition: TimeInterval = 0.0
    
    @State private var isPresentingAverageRuleMark = false
    @State private var isPresentingAllReadingDataSheet = false
    
    // MARK: - COMPUTED PROPERTIES

    var mainReadingTime: MainReadingTime? {
        guard !completeBook.records.isEmpty else {
            return nil
        }
        
        var period = ["dawn": 0, "morning": 0, "lunch": 0, "evening": 0]
        
        var readingDate: [Date] = []
        
        for record in completeBook.records {
            readingDate.append(record.date)
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
        var readingDate: [Date] = []
        
        for record in completeBook.records {
            readingDate.append(record.date)
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
    
    var scrollPositionStart: Date {
        Date(timeIntervalSinceReferenceDate: scrollPosition)
    }
    
    var scrollPositionEnd: Date {
        scrollPositionStart.addingTimeInterval(3600 * 14 * 24)
    }
    
    var scrollPositionStartString: String {
        scrollPositionStart.standardDateFormat
    }
    
    var scrollPositionEndString: String {
        scrollPositionEnd.toFormat("M월 d일 (E)")
    }
    
    // MARK: - INTILALZIER
    init(_ completeBook: CompleteBook) {
        self.completeBook = completeBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        analysisContent
            .onAppear {
                if let lastRecord = completeBook.lastRecord {
                    scrollPosition = lastRecord.date.addingTimeInterval(3600 * 24 * 14 * -1).timeIntervalSinceReferenceDate
                }
            }
            .onChange(of: completeBook.records) { _ in
                if let lastRecord = completeBook.lastRecord {
                    scrollPosition = lastRecord.date.addingTimeInterval(3600 * 24 * 14 * -1).timeIntervalSinceReferenceDate
                }
            }
            .sheet(isPresented: $isPresentingAllReadingDataSheet) {
                CompleteBookDataSheetView(completeBook)
                    .presentationCornerRadius(30)
            }
    }
    
    func totalReadPagesInPreiod(in range: ClosedRange<Date>) -> Int {
        completeBook.records.filter({ range.contains($0.date) }).reduce(0) { $0 + $1.numOfPagesRead }
    }
    
    func averageReadPagesInPreiod(in range: ClosedRange<Date>) -> Int {
        totalReadPagesInPreiod(in: range) / readPagesCountInPeriod(in: range)
    }
    
    func readPagesCountInPeriod(in range: ClosedRange<Date>) -> Int {
        let count = completeBook.records.filter({ range.contains($0.date) }).count
        return count != 0 ? count : 1
    }
}

// MARK: - EXTENSIONS

extension CompleteBookAnalysisView {
    var analysisContent: some View {
        Group {
            if completeBook.records.isEmpty {
                VStack(spacing: 5) {
                    Text("차트를 표시할 수 없음")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("독서를 시작해보세요.")
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                .padding(.bottom, 40)
            } else {
                VStack {
                    // for iOS 17.0
                    #if false
                    chartTitle
                    
                    barChart
                    
                    dailyAverageValueButton
                    #endif
                    
                    hightlightLabel
                    
                    seeAllRecordButton
                }
                //.padding([.leading, .bottom, .trailing]) // for iOS 17.0
                //.padding(.top, 5) // for iOS 17.0
            }
        }
    }
    
    @available(iOS 17.0, *)
    var chartTitle: some View {
        VStack(alignment: .leading, spacing: -2) {
            Text("총 읽은 페이지")
                .font(.callout.weight(.semibold))
                .foregroundStyle(Color.secondary)
            
            HStack(alignment: .firstTextBaseline) {
                Text("\(totalReadPagesInPreiod(in: scrollPositionStart...scrollPositionEnd))")
                    .font(.title.weight(.bold))
                    .foregroundStyle(completeBook.category.themeColor)
                Text("페이지")
                    .font(.headline)
                    .foregroundStyle(completeBook.category.themeColor)
                Spacer()
            }
            
            Text("\(scrollPositionStartString) ~ \(scrollPositionEndString)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.secondary)
        }
    }
    
    @available(iOS 17.0, *)
    var barChart: some View {
        Chart {
            ForEach(completeBook.records, id: \.self) { record in
                BarMark(
                    x: .value("date", record.date, unit: .day),
                    y: .value("page", record.numOfPagesRead)
                )
                .foregroundStyle(completeBook.category.themeColor)
            }
            
            if isPresentingAverageRuleMark {
                RuleMark(
                    y: .value(
                        "average",
                        averageReadPagesInPreiod(in: scrollPositionStart...scrollPositionEnd)
                    )
                )
                .lineStyle(StrokeStyle(lineWidth: 3))
                .foregroundStyle(completeBook.category.themeColor == Color.black ? Color.gray : Color.black)
                .annotation(position: .top, alignment: .leading) {
                    Text("일 평균 독서 페이지: \(averageReadPagesInPreiod(in: scrollPositionStart...scrollPositionEnd))")
                        .font(.headline)
                        .foregroundStyle(completeBook.category.themeColor == Color.black ? Color.gray : Color.black)
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 3600 * 24 * 14)
        .chartScrollTargetBehavior(
            .valueAligned(
                matching: DateComponents(hour: 0),
                majorAlignment: .matching(.init(day: 1))
            )
        )
        .chartScrollPosition(x: $scrollPosition)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 7)) {
                AxisTick()
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
        .frame(height: 250)
    }
    
    var hightlightLabel: some View {
        VStack {
            Text("하이라이트")
                .font(.title3.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
            
                HStack {
                    if let time = mainReadingTime {
                        Image(systemName: time.systemImage)
                            .font(.largeTitle)
                            .foregroundColor(time.themeColor)
                        
                        VStack(alignment: .leading) {
                            Text("주 독서 시간대")
                                .font(.caption)
                                .foregroundColor(Color.gray)
                            Text("\(time.name)")
                                .font(.title2.weight(.bold))
                                .foregroundColor(time.themeColor)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(.background), in: .rect(cornerRadius: 20))
                
                HStack {
                    if let days = consecutiveReadingDay {
                        Image(systemName: "calendar.circle.fill")
                            .font(.largeTitle)
                        
                        VStack(alignment: .leading) {
                            Text("연속 스트릭")
                                .font(.caption)
                                .foregroundColor(Color.gray)
                            Text("\(days)일")
                                .font(.title2.weight(.bold))
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(.background), in: .rect(cornerRadius: 20))
            }
        }
        .padding(.top, 5)
        .padding([.horizontal, .bottom])
    }
    
    var seeAllRecordButton: some View {
        Button {
            isPresentingAllReadingDataSheet = true
        } label: {
            Text("모든 데이터 보기")
                .font(.headline.weight(.bold))
                .foregroundColor(.primary)
                .frame(height: 45)
                .frame(maxWidth: .infinity)
                .background(Color("Background"))
                .clipShape(.capsule(style: .continuous))
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    var dailyAverageValueButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPresentingAverageRuleMark.toggle()
            }
        } label: {
            HStack {
                Text("일 평균 독서 페이지")
                    .fontWeight(.bold)
                
                Spacer()
                
                if !completeBook.records.isEmpty {
                    Text("\(averageReadPagesInPreiod(in: scrollPositionStart...scrollPositionEnd))")
                } else {
                    Text("-")
                }
            }
            .padding()
            .foregroundColor(isPresentingAverageRuleMark ? Color.white : Color.black)
            .background(isPresentingAverageRuleMark ? completeBook.category.themeColor : Color("Background"))
            .clipShape(.rect(cornerRadius: 20))
            .padding(.vertical, 5)
        }
    }
}

// MARK: - PREVIEW

struct ReadingBookAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteBookAnalysisView(CompleteBook.preview)
    }
}
