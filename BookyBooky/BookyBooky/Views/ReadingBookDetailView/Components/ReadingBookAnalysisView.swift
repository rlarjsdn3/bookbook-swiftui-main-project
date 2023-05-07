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
    
    @State private var selectedRecord: ReadingRecords?
    @State private var plotWidth: CGFloat = 0.0
    
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
                Text("일일 독서 차트")
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
            
            // 차트 미완성
//                Text("Charts Area")
//                    .font(.title.weight(.light))
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 300)
//                    .padding()
//                    .background(Color("Background"))
//                    .cornerRadius(20)
//                    .padding([.horizontal, .bottom])
        
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
                            
                            if let selectedRecord, selectedRecord.date.formatted(.dateTime.year().month().day()) == record.date.formatted(.dateTime.year().month().day()) {
                                RuleMark(x: .value("Date", record.date))
                                    .offset(x: -5) // 수정할 필요 있음!
                                    .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                                    .foregroundStyle(Color.gray.opacity(0.5))
                                    .annotation(position: .top) {
                                        VStack(alignment: .leading) {
                                            Text("\(record.date.formatted(.dateTime.month().day().locale(Locale(identifier: "ko_kr"))))")
                                                .font(.caption.weight(.bold))
                                            Text("\(record.numOfPagesRead)페이지")
                                                .font(.title2.weight(.light))
                                        }
                                        .padding(.vertical, 3)
                                        .padding(.horizontal, 8)
                                        .background {
                                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                                .fill(Color("Background"))
                                        }
                                    }
                            }
                            
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
                .chartXScale(range: 0...(mainScreen.width * 0.82))
                .chartYScale(domain: 0...50)
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
                .chartOverlay { outerProxy in
                    GeometryReader { innerProxy in
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { newValue in
                                        let location = newValue.location
                                        
                                        if let date: Date = outerProxy.value(atX: location.x) {
                                            let calendar = Calendar.current
                                            let year = calendar.component(.year, from: date)
                                            let month = calendar.component(.month, from: date)
                                            let day = calendar.component(.day, from: date)
                                            
                                            if let currentItem = readingBook.readingRecords.first(where: { item in
                                                calendar.component(.year, from: item.date) == year &&
                                                calendar.component(.month, from: item.date) == month &&
                                                calendar.component(.day, from: item.date) == day
                                            }) {
                                                selectedRecord = currentItem
                                                plotWidth = outerProxy.plotAreaSize.width
                                                print(currentItem.date.formatted(.dateTime.year().month().day()))
                                            }
                                        }
                                    }
                                    .onEnded { newValue in
                                        selectedRecord = nil
                                    }
                            )
                            .foregroundStyle(readingBook.category.accentColor.gradient)
                    }
                }
                .frame(height: 300)
                .padding(.horizontal)
                
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
}

struct ReadingBookAnalysisView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        ReadingBookAnalysisView(readingBook: readingBooks[0])
    }
}
