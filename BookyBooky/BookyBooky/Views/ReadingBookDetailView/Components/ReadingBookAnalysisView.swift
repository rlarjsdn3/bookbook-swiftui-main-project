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
    
    @State var selectedElement: ReadingRecords?
    
    @State private var isOnAverageValue = false
    @State private var isPresentingAllReadingDataSheet = false
    
    var filteredChartsData: [ReadingRecords] {
        var filter: [ReadingRecords] = []
        
        switch selectedDateRange {
        case .oneMonth:
            if let lastRecords = readingBook.readingRecords.last {
                let timeInterval = DateInterval(start: lastRecords.date.addingTimeInterval(-86400 * 30), end: lastRecords.date)
                for record in readingBook.readingRecords {
                    if timeInterval.contains(record.date) {
                        filter.append(record)
                    }
                }
            }
            return filter
        case .oneYear:
            if let lastRecords = readingBook.readingRecords.last {
                let timeInterval = DateInterval(start: lastRecords.date.addingTimeInterval(-86400 * 365), end: lastRecords.date)
                for record in readingBook.readingRecords {
                    if timeInterval.contains(record.date) {
                        filter.append(record)
                    }
                }
            }
            return filter
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("일일 독서 그래프")
                    .font(.title3.weight(.semibold))
                
                Picker(selection: $selectedDateRange.animation(.easeInOut)) {
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
            // - 차트 디자인 다듬기
            // - Y축 범위 설정하기
            // - 분석 탭 UI 수정하기 (평균 독서 페이지 보기 버튼)
            // - 지난 30일 / 지난 1년 차트 데이터 처리 방식 변경하기
            
            Chart {
                ForEach(filteredChartsData, id: \.self) { record in
                    if selectedDateRange == .oneMonth {
                        BarMark(
                            x: .value("Date", record.date, unit: .day),
                            y: .value("Page", record.numOfPagesRead),
                            width: .ratio(0.6)
                        )
                        .foregroundStyle(readingBook.category.accentColor.gradient)
                        .opacity(isOnAverageValue ? 0.3 : 1)
                        
                        if isOnAverageValue {
                            RuleMark(
                                y: .value("Average", readingBook.readingRecords.reduce(0, { $0 + $1.numOfPagesRead }) / readingBook.readingRecords.count)
                            )
                            .foregroundStyle(Color.black)
                            .annotation(position: .top, alignment: .leading) {
                                Text("평균 독서 페이지: \(readingBook.readingRecords.reduce(0, { $0 + $1.numOfPagesRead }) / readingBook.readingRecords.count)")
                            }
                        }
                    } else {
                        BarMark(
                            x: .value("Date", record.date, unit: .month),
                            y: .value("Page", record.numOfPagesRead),
                            width: .ratio(0.6)
                        )
                        .foregroundStyle(readingBook.category.accentColor.gradient)
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    if selectedDateRange == .oneMonth {
                        
                        let date = value.as(Date.self)!
                        let components1 = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
                        
                        
                        if value.as(Date.self)!.isFirstMonth() {
                            AxisGridLine()
                                .foregroundStyle(Color.black.opacity(0.5))
                            AxisTick()
                            let label = "\(value.as(Date.self)!.formatted(.dateTime.month().locale(Locale(identifier: "ko_kr"))))"
                            AxisValueLabel(label)
                                .foregroundStyle(.black)
                        } else if components1.weekday == 1 {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.day().locale(Locale(identifier: "ko_kr")))
                        }
                        
                    }
                }
            }
            .chartXScale(range: 0...mainScreen.width * 0.83)
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
                            let boxWidth: CGFloat = 150
                            let boxOffset = max(0, min(geo.size.width - boxWidth, midStartPositionX - boxWidth / 2))

                          Rectangle()
                              .fill(.quaternary)
                              .frame(width: 2, height: lineHeight)
                              .position(x: midStartPositionX, y: lineHeight / 2)

                            VStack(alignment: .leading) {
                              Text("\(selectedElement.date, format: .dateTime.year().month().day())")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                Text("\(selectedElement.numOfPagesRead , format: .number) calories")
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
        
            
            
            
            
            
            /*
            
                .chartXScale(range: 0...(mainScreen.width * 0.82))
                .chartYScale(domain: 0...20)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        if selectedDateRange == .oneMonth {
                            
                            let date = value.as(Date.self)!
                            let components1 = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
                            
                            
                            if value.as(Date.self)!.isFirstMonth() {
                                AxisGridLine()
                                    .foregroundStyle(Color.black.opacity(0.5))
                                AxisTick()
                                let label = "\(value.as(Date.self)!.formatted(.dateTime.month().locale(Locale(identifier: "ko_kr"))))"
                                AxisValueLabel(label)
                                    .foregroundStyle(.black)
                            } else if components1.weekday == 1 {
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel(format: .dateTime.day().locale(Locale(identifier: "ko_kr")))
                            }
                            
                        }
                    }
                }
                .frame(height: 300)
                .padding(.horizontal)
             */
                
                VStack {
                    Divider()
                    
                    Toggle(isOn: $isOnAverageValue) {
                        Text("평균 독서 페이지 보기")
                    }
                    .tint(readingBook.category.accentColor)
                    
                    Divider()
                }
                .padding()
            
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
    }

    func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> ReadingRecords? {
        print("location.x - \(location.x)")
        print("geometry[proxy.plotAreaFrame].origin.x - \(geometry[proxy.plotAreaFrame].origin.x)")
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in readingBook.readingRecords.indices {
                let nthDataDistance = readingBook.readingRecords[dataIndex].date.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return readingBook.readingRecords[index]
            }
        }
        return nil
    }
}

struct ReadingBookAnalysisView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        ReadingBookAnalysisView(readingBook: readingBooks[0])
    }
}
