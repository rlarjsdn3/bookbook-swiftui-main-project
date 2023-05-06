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
    case oneWeek
    case oneMonth
    case sixMonth
    case oneYear
    
    var name: String {
        switch self {
        case .oneWeek:
            return "1주일"
        case .oneMonth:
            return "1개월"
        case .sixMonth:
            return "6개월"
        case .oneYear:
            return "1년"
        }
    }
}

struct ReadingBookAnalysisView: View {
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var selectedDateRange: AnalysisDateRangeTabItems = .oneWeek
    
    @State private var isPresentingAllReadingDataSheet = false
    
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
                .padding(.vertical, 10)
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
                    ForEach(readingBook.readingRecords, id: \.self) { record in
                        BarMark(
                            x: .value("Date", record.date, unit: .day),
                            y: .value("Page", record.numOfPagesRead)
                        )
                        .foregroundStyle(readingBook.category.accentColor.gradient)
                    }
                }
                .chartXAxis {
                    AxisMarks(preset: .extended, values: .stride(by: .day)) { value in
                        let date = value.as(Date.self)!
                        let components1 = Calendar.current.dateComponents([.year, .month, .day], from: date)
                        let components2 = Calendar.current.dateComponents([.year, .month, .day], from: readingBook.readingRecords.first?.date ?? Date().addingTimeInterval(86400 * 1000))
                        
                        if components1.year == components2.year && components1.month == components2.month && components1.day == components2.day {
                            AxisGridLine()
                                .foregroundStyle(Color.black.opacity(0.5))
                            let label = "\(components1.day!)일\n\(value.as(Date.self)!.formatted(.dateTime.month().locale(Locale(identifier: "ko_kr"))))"
                            AxisValueLabel(label, centered: true)
                                .foregroundStyle(.black)
                        } else if value.as(Date.self)!.isFirstMonth() {
                            AxisGridLine()
                                .foregroundStyle(Color.black.opacity(0.5))
                            let label = "1\n\(value.as(Date.self)!.formatted(.dateTime.month().locale(Locale(identifier: "ko_kr"))))"
                            AxisValueLabel(label, centered: true)
                                .foregroundStyle(.black)
                        } else {
                            AxisValueLabel(format: .dateTime.day().locale(Locale(identifier: "ko_kr")), centered: true)
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
                    }
                }
                .frame(maxWidth: .infinity)
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
