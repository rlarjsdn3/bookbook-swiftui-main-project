//
//  ReadingBookRecordsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import Charts
import RealmSwift

enum AnalysisDateRangeTabItems: CaseIterable {
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

struct ReadingBookAnalysisView: View {
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var selectedDateRange: AnalysisDateRangeTabItems = .oneMonth
    
    @State private var selectedElement: DailyReading?
    
    @State private var isOnAverageValue = false
    @State private var isPresentingAllReadingDataSheet = false
    
    private struct DailyReading: Hashable {
        var date: Date
        var pagesRead: Int
    }
    
    private struct MonthlyReading {
        var date: Date
        var pagesRead: Int
    }
    
    private var filteredChartsData: [DailyReading] {
        var filter: [DailyReading] = []
        
        switch selectedDateRange {
        case .oneMonth:
            if let lastRecord = readingBook.readingRecords.last {
                for i in 0..<31 {
                    filter.append(DailyReading(date: Date(timeInterval: Double(86400 * -i), since: lastRecord.date), pagesRead: 0))
                }
                
                for record in readingBook.readingRecords {
                    let component2 = Calendar.current.dateComponents([.year, .month, .day], from: record.date)
                    
                    if let index = filter.firstIndex(where: { item in
                        let comp = Calendar.current.dateComponents([.year, .month, .day], from: item.date)
                        
                        return component2.year == comp.year && component2.month == comp.month && component2.day == comp.day
                    }) {
                        filter[index].pagesRead = record.numOfPagesRead
                    }
                }
                return filter
            }
        case .oneYear:
            // 12개월 전체 보도록 만들기
            
            if let lastRecord = readingBook.readingRecords.last {
                
                for i in 0..<12 {
                    filter.append(DailyReading(date: Date(timeInterval: Double(86400 * 30 * -i), since: lastRecord.date), pagesRead: 0))
                }
                
                for record in readingBook.readingRecords {
                    let comp = Calendar.current.dateComponents([.year, .month], from: record.date)
                    
                    if let index = filter.firstIndex(where: { item in
                        let comp2 = Calendar.current.dateComponents([.year, .month], from: item.date)
                        
                        return comp.year == comp2.year && comp.month == comp2.month
                    }) {
                        filter[index].pagesRead += record.numOfPagesRead
                    } else {
                        filter.append(DailyReading(date: record.date, pagesRead: record.numOfPagesRead))
                    }
                }
            }
            return filter
        }
        return filter
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("일일 독서 그래프")
                    .font(.title3.weight(.semibold))
                
                Picker(selection: $selectedDateRange) {
                    ForEach(AnalysisDateRangeTabItems.allCases, id: \.self) { item in
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
        
            // 내일 할 일
            // - 전체 코드 이해하기 (주석으로 다 달기)
            // - 분석 탭 UI 수정하기 (평균 독서 페이지 보기 버튼)
            
            if !filteredChartsData.isEmpty {
                Chart {
                    ForEach(filteredChartsData, id: \.self) { record in
                        if selectedDateRange == .oneMonth {
                            BarMark(
                                x: .value("Date", record.date, unit: .day),
                                y: .value("Page", record.pagesRead),
                                width: .ratio(0.6)
                            )
                            .foregroundStyle(readingBook.category.accentColor.gradient)
                            .opacity(isOnAverageValue ? 0.3 : 1)
                            
                            if isOnAverageValue {
                                let average = filteredChartsData.reduce(0, { $0 + $1.pagesRead }) / countChartsData(filteredChartsData)
                                
                                RuleMark(
                                    y: .value("Average", average)
                                )
                                .foregroundStyle(Color.black)
                                .annotation(position: .top, alignment: .leading) {
                                    Text("일 평균 독서 페이지: \(average)")
                                }
                            }
                        } else {
                            BarMark(
                                x: .value("Date", record.date, unit: .month),
                                y: .value("Page", record.pagesRead),
                                width: .ratio(0.6)
                            )
                            .foregroundStyle(readingBook.category.accentColor.gradient)
                            .opacity(isOnAverageValue ? 0.3 : 1)
                            
                            if isOnAverageValue {
                                let average = filteredChartsData.reduce(0, { $0 + $1.pagesRead }) / countChartsData(filteredChartsData)
                                
                                RuleMark(
                                    y: .value("Average", average)
                                )
                                .foregroundStyle(Color.black)
                                .annotation(position: .top, alignment: .leading) {
                                    Text("월 평균 독서 페이지: \(average)")
                                }
                            }
                        }
                        
                        
                    }
                }
                .chartXAxis {
                    if selectedDateRange == .oneMonth {
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
                                        if selectedElement?.date == element?.date {
                                            // If tapping the same element, clear the selection.
                                            selectedElement = nil
                                        } else {
                                            selectedElement = element
                                        }
                                    }
                                    .exclusively(
                                        before: DragGesture()
                                            .onChanged { value in
                                                selectedElement = findElement(location: value.location, proxy: proxy, geometry: geo)
                                            }
                                            .onEnded { _ in
                                                selectedElement = nil
                                            }
                                    )
                            )
                    }
                }
                .chartBackground { proxy in
                    ZStack(alignment: .topLeading) {
                        GeometryReader { geo in
                            if let selectedElement = selectedElement {
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
                                    if selectedDateRange == .oneMonth {
                                        Text(selectedElement.date.formatted(.dateTime.year().month().day().locale(Locale(identifier: "ko_kr"))))
                                            .font(.callout)
                                            .foregroundStyle(.secondary)
                                    } else {
                                        Text(selectedElement.date.formatted(.dateTime.year().month().locale(Locale(identifier: "ko_kr"))))
                                            .font(.callout)
                                            .foregroundStyle(.secondary)
                                    }
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
                        .font(.title.weight(.bold))
                    
                    Text("그래프를 보려면 독서 데이터를 추가하십시오.")
                        .fontWeight(.light)
                        .minimumScaleFactor(0.5)
                }
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                .background(Color("Background"))
                .cornerRadius(20)
                .padding(.horizontal)
            }
                
            // 도서 데이터가 아무것도 없는 경우 발생하는 오류 해결 + 코드 리팩토링하기
            
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isOnAverageValue.toggle()
                }
            } label: {
                if selectedDateRange == .oneMonth {
                    HStack {
                        Text("일 평균 독서 페이지")
                            .fontWeight(.bold)
                        Spacer()
                        if !filteredChartsData.isEmpty {
                            Text("\(filteredChartsData.reduce(0, { $0 + $1.pagesRead }) / countChartsData(filteredChartsData))")
                        } else {
                            Text("-")
                        }
                    }
                    .padding()
                    .foregroundColor(isOnAverageValue ? Color.white : Color.black)
                    .background(isOnAverageValue ? readingBook.category.accentColor : Color("Background"))
                    .cornerRadius(20)
                    .padding()
                } else {
                    HStack {
                        Text("월 평균 독서 페이지")
                            .fontWeight(.bold)
                        Spacer()
                        if !filteredChartsData.isEmpty {
                            Text("\(filteredChartsData.reduce(0, { $0 + $1.pagesRead }) / countChartsData(filteredChartsData))")
                        } else {
                            Text("-")
                        }
                    }
                    .padding()
                    .foregroundColor(isOnAverageValue ? Color.white : Color.black)
                    .background(isOnAverageValue ? readingBook.category.accentColor : Color("Background"))
                    .cornerRadius(20)
                    .padding()
                }
            }
            .disabled(filteredChartsData.isEmpty)
            
            HStack {
                Text("Highlight")
                    .font(.title.weight(.light))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding()
                    .background(Color("Background"))
                    .cornerRadius(20)
                    .padding([.bottom])
                
                Text("Highlight")
                    .font(.title.weight(.light))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding()
                    .background(Color("Background"))
                    .cornerRadius(20)
                    .padding([.bottom])
            }
            .padding(.horizontal)
            
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
        .onChange(of: selectedDateRange) { _ in
            selectedElement = nil
        }
    }

    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> DailyReading? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in filteredChartsData.indices {
                let nthDataDistance = filteredChartsData[dataIndex].date.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return filteredChartsData[index]
            }
        }
        return nil
    }
    
    private func countChartsData(_ datas: [DailyReading]) -> Int {
        var count = 0
        
        for data in datas where data.pagesRead > 0 {
            count += 1
        }
        return count
    }
}

struct ReadingBookAnalysisView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        ReadingBookAnalysisView(readingBook: readingBooks[0])
    }
}
