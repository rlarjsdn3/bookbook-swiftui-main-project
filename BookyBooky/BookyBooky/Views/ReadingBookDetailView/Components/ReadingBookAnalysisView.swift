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
            VStack {
                HStack {
                    Text("일일 독서 차트")
                        .font(.title3.weight(.semibold))
                        .padding(.horizontal)
                    
                    Picker(selection: $selectedDateRange.animation(.easeInOut)) {
                        ForEach(AnalysisDateRangeTabItems.allCases, id: \.self) { item in
                            Text(item.name)
                        }
                    } label: {
                        Text("Label")
                    }
                    .pickerStyle(.segmented)
                    .padding(.trailing)
                }
                .padding(.top, 10)
                .padding(.bottom, 60)
                
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
//                            .position(by: .value("Date", record.date))
                            .foregroundStyle(readingBook.category.accentColor.gradient)
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
                .chartXScale(range: 0...(mainScreen.width * 0.83))
//                .chartXScale(domain: Date().addTimeInterval(86400 * -7)...Date())
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
                                        
                                        if let day: Date = outerProxy.value(atX: location.x) {
                                            print(day)
                                        }
                                    }
                            )
                            .foregroundStyle(readingBook.category.accentColor.gradient)
                    }
                }
                .frame(height: 300)
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
            }
            .background(Color.white)
            
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
