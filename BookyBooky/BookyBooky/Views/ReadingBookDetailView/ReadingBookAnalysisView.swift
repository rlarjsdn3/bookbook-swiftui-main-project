//
//  ReadingBookRecordsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import Charts
import RealmSwift

enum ChartDateRangeTabItems: CaseIterable {
    case oneMonth
    case oneYear
    
    var name: String {
        switch self {
        case .oneMonth:
            return "지난 30일"
        case .oneYear:
            return "지난 1년"
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
    
    // MARK: - INNER STRUCT
    
    private struct ReadingData: Hashable {
        var date: Date
        var pagesRead: Int
    }
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var selectedChartDateRange: ChartDateRangeTabItems = .oneMonth
    @State private var selectedChartElement: ReadingData?
    
    @State private var isShowingAverageRuleMark = false
    @State private var isPresentingAllReadingDataSheet = false
    
    // MARK: - COMPUTED PROPERTIES
    
    private var filteredChartDataArray: [ReadingData] {
        var filterChartDataArray: [ReadingData] = []
        
        switch selectedChartDateRange {
        case .oneMonth:
            if let lastRecord = readingBook.readingRecords.last {
                for i in 0..<31 {
                    filterChartDataArray.append(ReadingData(date: Date(timeInterval: Double(86400 * -i), since: lastRecord.date), pagesRead: 0))
                }
                
                for record in readingBook.readingRecords {
                    if let index = filterChartDataArray.firstIndex(where: { element in
                        return record.date.isEqual([.year, .month, .day], date: element.date)
                    }) {
                        filterChartDataArray[index].pagesRead = record.numOfPagesRead
                    }
                }
            }
            return filterChartDataArray
        case .oneYear:
            if let lastRecord = readingBook.readingRecords.last {
                for i in 0..<12 {
                    filterChartDataArray.append(ReadingData(date: Date(timeInterval: Double(86400 * 30 * -i), since: lastRecord.date), pagesRead: 0))
                }
                
                for record in readingBook.readingRecords {
                    if let index = filterChartDataArray.firstIndex(where: { element in
                        return record.date.isEqual([.year, .month], date: element.date)
                    }) {
                        filterChartDataArray[index].pagesRead += record.numOfPagesRead
                    } else {
                        filterChartDataArray.append(ReadingData(date: record.date, pagesRead: record.numOfPagesRead))
                    }
                }
            }
            return filterChartDataArray
        }
    }
    
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
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            HStack {
                Text("독서 그래프")
                    .font(.title3.weight(.semibold))
                
                Picker(selection: $selectedChartDateRange) {
                    ForEach(ChartDateRangeTabItems.allCases, id: \.self) { item in
                        Text(item.name)
                    }
                } label: {
                    Text("Label")
                }
                .pickerStyle(.segmented)
                .padding(.leading)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 50)
        
            // MARK: - CHART (TEMP)
            
            barChart
            
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isShowingAverageRuleMark.toggle()
                }
            } label: {
                HStack {
                    Group {
                        if selectedChartDateRange == .oneMonth {
                            Text("일 평균 독서 페이지")
                        } else {
                            Text("월 평균 독서 페이지")
                        }
                    }
                    .fontWeight(.bold)
                    
                    Spacer()
                    
                    if !filteredChartDataArray.isEmpty {
                        Text("\(getAverageValue())")
                    } else {
                        Text("-")
                    }
                }
                .padding()
                .foregroundColor(isShowingAverageRuleMark ? Color.white : Color.black)
                .background(isShowingAverageRuleMark ? readingBook.category.accentColor : Color("Background"))
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.vertical, 5)
            }
            .disabled(filteredChartDataArray.isEmpty)
            
            Section {
                HStack {
                    // ... 주 독서 시간대
                    
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
                    
                    // ... 연속 스트릭
                    
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
                .padding(.horizontal)
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
                        .padding(.horizontal)
                        .background(Color("Background"))
                        .clipShape(Capsule(style: .continuous))
                        .opacity(readingBook.readingRecords.isEmpty ? 0.3 : 1)
                }
                .disabled(readingBook.readingRecords.isEmpty)
                .padding([.horizontal, .bottom])
            }
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $isPresentingAllReadingDataSheet) {
            AllReadingDataView(readingBook: readingBook)
        }
        .onChange(of: selectedChartDateRange) { _ in
            selectedChartElement = nil
        }
    }

    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> ReadingData? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in filteredChartDataArray.indices {
                let nthDataDistance = filteredChartDataArray[dataIndex].date.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return filteredChartDataArray[index]
            }
        }
        return nil
    }
    
    private func getAverageValue() -> Int {
        return filteredChartDataArray.reduce(0, { $0 + $1.pagesRead }) / countChartData()
    }
    
    private func countChartData() -> Int {
        var count = 0
        
        for data in filteredChartDataArray where data.pagesRead > 0 {
            count += 1
        }
        return count
    }
}

// MARK: - EXTENSIONS

extension ReadingBookAnalysisView {
    var barChart: some View {
        Group {
            if !filteredChartDataArray.isEmpty {
                Chart {
                    ForEach(filteredChartDataArray, id: \.self) { record in
                        if selectedChartDateRange == .oneMonth {
                            BarMark(
                                x: .value("Date", record.date, unit: .day),
                                y: .value("Page", record.pagesRead),
                                width: .ratio(0.6)
                            )
                            .foregroundStyle(readingBook.category.accentColor.gradient)
                            .opacity(isShowingAverageRuleMark ? 0.3 : 1)
                        } else {
                            BarMark(
                                x: .value("Date", record.date, unit: .month),
                                y: .value("Page", record.pagesRead),
                                width: .ratio(0.6)
                            )
                            .foregroundStyle(readingBook.category.accentColor.gradient)
                            .opacity(isShowingAverageRuleMark ? 0.3 : 1)
                        }
                        
                        if isShowingAverageRuleMark {
                            RuleMark(
                                y: .value("Average", getAverageValue())
                            )
                            .foregroundStyle(Color.black)
                            .annotation(position: .top, alignment: .leading) {
                                if selectedChartDateRange == .oneMonth {
                                    Text("일 평균 독서 페이지: \(getAverageValue())")
                                } else {
                                    Text("월 평균 독서 페이지: \(getAverageValue())")
                                }
                            }
                        }
                        
                        
                    }
                }
                .chartXAxis {
                    if selectedChartDateRange == .oneMonth {
                        AxisMarks(values: .stride(by: .day)) { value in
                            
                            let date = value.as(Date.self)!
                            let components1 = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
                            
                            if components1.weekday == 1 {
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel(format: .dateTime.day().locale(Locale(identifier: "ko_kr")))
                            }
                            
                        }
                    } else {
                        AxisMarks(values: .stride(by: .month)) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.month(.defaultDigits))
                        }
                    }
                }
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                SpatialTapGesture()
                                    .onEnded { value in
                                        let element = findElement(location: value.location, proxy: proxy, geometry: geo)
                                        if selectedChartElement?.date == element?.date {
                                            // If tapping the same element, clear the selection.
                                            selectedChartElement = nil
                                        } else {
                                            selectedChartElement = element
                                        }
                                    }
                                    .exclusively(
                                        before: DragGesture()
                                            .onChanged { value in
                                                selectedChartElement = findElement(location: value.location, proxy: proxy, geometry: geo)
                                            }
                                            .onEnded { _ in
                                                selectedChartElement = nil
                                            }
                                    )
                            )
                    }
                }
                .chartBackground { proxy in
                    ZStack(alignment: .topLeading) {
                        GeometryReader { geo in
                            if let selectedElement = selectedChartElement {
                                let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedElement.date)!
                                let startPositionX = proxy.position(forX: dateInterval.start) ?? 0
                                let midStartPositionX = startPositionX + geo[proxy.plotAreaFrame].origin.x + 5
                                let lineHeight = geo[proxy.plotAreaFrame].maxY
                                let boxWidth: CGFloat = 120
                                let boxOffset = max(0, min(geo.size.width - boxWidth, midStartPositionX - boxWidth / 2))
                                
                                Rectangle()
                                    .fill(.quaternary)
                                    .frame(width: 2, height: lineHeight)
                                    .position(x: midStartPositionX, y: lineHeight / 2)
                                
                                VStack(alignment: .leading) {
                                    Group {
                                        if selectedChartDateRange == .oneMonth {
                                            Text(selectedElement.date.formatted(.dateTime.year().month().day().locale(Locale(identifier: "ko_kr"))))
                                        } else {
                                            Text(selectedElement.date.formatted(.dateTime.year().month().locale(Locale(identifier: "ko_kr"))))
                                        }
                                    }
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                                                                
                                    Text("\(selectedElement.pagesRead, format: .number) 페이지")
                                        .font(.title2.bold())
                                        .foregroundColor(.primary)
                                }
                                .frame(width: boxWidth, alignment: .leading)
                                .background {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.background)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.quaternary.opacity(0.7))
                                    }
                                    .padding([.leading, .trailing], -8)
                                    .padding([.top, .bottom], -4)
                                }
                                .offset(x: boxOffset, y: -58)
                            }
                        }
                    }
                }
                .frame(height: 250)
                .padding()
            } else {
                VStack(spacing: 5) {
                    Text("그래프를 그릴 수 없음")
                        .font(.title2.weight(.bold))
                    
                    Text("그래프를 보려면 독서 데이터를 추가하십시오.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .minimumScaleFactor(0.5)
                }
                .frame(height: 280)
                .frame(maxWidth: .infinity)
                .background(Color("Background"))
                .cornerRadius(20)
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - PREVIEW

struct ReadingBookAnalysisView_Previews: PreviewProvider {    
    static var previews: some View {
        ReadingBookAnalysisView(readingBook: ReadingBook.preview)
    }
}
