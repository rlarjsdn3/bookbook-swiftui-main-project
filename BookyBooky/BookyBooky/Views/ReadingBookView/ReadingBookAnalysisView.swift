//
//  ReadingBookRecordsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import Charts
import RealmSwift

// 차트 수정해보기

enum ChartDateRangeTabItems: CaseIterable {
    case month
    case year
    
    var name: String {
        switch self {
        case .month:
            return "30일"
        case .year:
            return "1년"
        }
    }
}

enum HighlightMajorReadingPeriodItems {
    case morning
    case lunch
    case evening
    case dawn
    case none
    
    var name: String {
        switch self {
        case .morning:
            return "아침"
        case .lunch:
            return "점심"
        case .evening:
            return "저녁"
        case .dawn:
            return "새벽"
        case .none:
            return "-"
        }
    }
    
    var systemImage: String {
        switch self {
        case .morning:
            return "sunrise.circle.fill"
        case .lunch:
            return "sun.max.circle.fill"
        case .evening:
            return "moon.circle.fill"
        case .dawn:
            return "moon.stars.circle.fill"
        case .none:
            return "circle"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .morning:
            return Color.yellow
        case .lunch:
            return Color.orange
        case .evening:
            return Color.red
        case .dawn:
            return Color.black
        case .none:
            return Color.gray
        }
    }
}

struct ReadingBookAnalysisView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var scrollPosition: TimeInterval = 0.0
    
    @State private var isPresentingAverageRuleMark = false
    @State private var isPresentingAllReadingDataSheet = false
    
    // MARK: - COMPUTED PROPERTIES

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
        scrollPositionEnd.standardDateFormat
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: -2) {
                Text("총 읽은 페이지")
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(Color.secondary)
                
                HStack(alignment: .firstTextBaseline) {
                    Text("\(totalReadPagesInPreiod(in: scrollPositionStart...scrollPositionEnd))")
                        .font(.title.weight(.bold))
                        .foregroundStyle(readingBook.category.accentColor)
                    Text("페이지")
                        .font(.headline)
                        .foregroundStyle(Color.secondary)
                    
                    Spacer()
                }
                
                Text("\(scrollPositionStartString) ~ \(scrollPositionEndString)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.secondary)
            }
            
            Chart(readingBook.readingRecords, id: \.self) { record in
                BarMark(
                    x: .value("date", record.date, unit: .day),
                    y: .value("page", record.numOfPagesRead)
                )
                .foregroundStyle(readingBook.category.accentColor)
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
            .frame(height: 300)
            
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPresentingAverageRuleMark.toggle()
                }
            } label: {
                HStack {
                    Text("일 평균 독서 페이지")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    if !readingBook.readingRecords.isEmpty {
                        Text("\(averageReadPagesInPreiod(in: scrollPositionStart...scrollPositionEnd))")
                    } else {
                        Text("-")
                    }
                }
                .padding()
                .foregroundColor(isPresentingAverageRuleMark ? Color.white : Color.black)
                .background(isPresentingAverageRuleMark ? readingBook.category.accentColor : Color("Background"))
                .cornerRadius(20)

                .padding(.vertical, 5)
            }
            .disabled(readingBook.readingRecords.isEmpty)
            
            Section {
                HStack {
                    HStack {
                        Image(systemName: highlightMajorReadingPeriod.systemImage)
                            .font(.largeTitle)
                            .foregroundColor(highlightMajorReadingPeriod.accentColor)
                        
                        VStack(alignment: .leading) {
                            Text("주 독서 시간대")
                                .font(.caption)
                                .foregroundColor(Color.gray)
                            Text("\(highlightMajorReadingPeriod.name)")
                                .font(.title2.weight(.bold))
                                .foregroundColor(highlightMajorReadingPeriod.accentColor)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color("Background"))
                    .cornerRadius(20)
                    .padding([.bottom])
                    
                    HStack {
                        if consecutiveReadingDays != 0 {
                            Image(systemName: "calendar.circle.fill")
                                .font(.largeTitle)
                        } else {
                            Image(systemName: "circle")
                                .font(.largeTitle)
                                .foregroundColor(Color.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("연속 스트릭")
                                .font(.caption)
                                .foregroundColor(Color.gray)
                            if consecutiveReadingDays != 0 {
                                Text("\(consecutiveReadingDays)일")
                                    .font(.title2.weight(.bold))
                            } else {
                                Text("-")
                                    .font(.title2.weight(.bold))
                                    .foregroundColor(Color.gray)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color("Background"))
                    .cornerRadius(20)
                    .padding([.bottom])
                }
            } header: {
                Text("하이라이트")
                    .font(.title3.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal, .top])
            }

            VStack {
                Button {
                    isPresentingAllReadingDataSheet = true
                } label: {
                    Text("모든 데이터 보기")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.primary)
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                        .background(Color("Background"))
                        .clipShape(Capsule(style: .continuous))
                        .opacity(readingBook.readingRecords.isEmpty ? 0.3 : 1)
                }
                .disabled(readingBook.readingRecords.isEmpty)
                .padding(.bottom)
            }
            .padding(.bottom, 20)
        }
        .onAppear {
            scrollPosition = readingBook.readingRecords.last!.date.addingTimeInterval(3600 * 24 * 14 * -1).timeIntervalSinceReferenceDate
        }
        .sheet(isPresented: $isPresentingAllReadingDataSheet) {
            ReadingBookDataSheetView(readingBook)
        }
        .padding()
    }
    
    func totalReadPagesInPreiod(in range: ClosedRange<Date>) -> Int {
        readingBook.readingRecords.filter({ range.contains($0.date) }).reduce(0) { $0 + $1.numOfPagesRead }
    }
    
    func averageReadPagesInPreiod(in range: ClosedRange<Date>) -> Int {
        totalReadPagesInPreiod(in: range) / readPagesCountInPeriod(in: range)
    }
    
    func readPagesCountInPeriod(in range: ClosedRange<Date>) -> Int {
        let count = readingBook.readingRecords.filter({ range.contains($0.date) }).count
        return count != 0 ? count : 1
    }
}

// MARK: - EXTENSIONS

extension ReadingBookAnalysisView {
    // 코드 깔끔하게 다듬기
    var highlightMajorReadingPeriod: HighlightMajorReadingPeriodItems {
        // 0번 - 새벽, 1번 - 아침, 2번 - 점심, 3번 저녁, 4번 - 없음
        var count = [Int](repeating: 0, count: 5)
        
        for records in readingBook.readingRecords {
            let hour = Calendar.current.dateComponents([.hour], from: records.date).hour!
            print(hour)
            
            switch hour {
            case _ where 0 < hour && hour <= 6:
                count[0] += 1
            case _ where 6 < hour && hour <= 12:
                count[1] += 1
            case _ where 12 < hour && hour <= 18:
                count[2] += 1
            case _ where 18 < hour && hour <= 24:
                count[3] += 1
            default:
                break
            }
        }
        
        var maxIndex = 4
        for index in count.indices where count[index] > count[maxIndex] {
            maxIndex = index
        }
        
        switch maxIndex {
        case 0:
            return .dawn
        case 1:
            return .morning
        case 2:
            return .lunch
        case 3:
            return .evening
        default:
            return .none
        }
    }
    
    var consecutiveReadingDays: Int {
        guard !readingBook.readingRecords.isEmpty else {
            return 0
        }
        
        var maxConsecutiveDays = 1
        var currentConsecutiveDays = 1
        
        for i in 1..<readingBook.readingRecords.count {
            let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: readingBook.readingRecords[i].date)!
            
            if previousDate.formatted(date: .abbreviated, time: .omitted) == readingBook.readingRecords[i-1].date.formatted(date: .abbreviated, time: .omitted) {
                currentConsecutiveDays += 1
            } else {
                maxConsecutiveDays = max(currentConsecutiveDays, maxConsecutiveDays)
                currentConsecutiveDays = 1
            }
        }
        
        return max(currentConsecutiveDays, maxConsecutiveDays)
    }
    
}

// MARK: - PREVIEW

struct ReadingBookAnalysisView_Previews: PreviewProvider {    
    static var previews: some View {
        ReadingBookAnalysisView(readingBook: ReadingBook.preview)
    }
}
