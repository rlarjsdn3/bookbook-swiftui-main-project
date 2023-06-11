//
//  monthlyCompleteBookChartView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/11/23.
//

import SwiftUI
import Charts

struct monthlyCompleteBookChartView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedTimeRange: TimeRange = .last14Days
    
    @State private var scrollPosition: TimeInterval = 0.0
    @State private var isPresentingAverageRuleMark = false
    
    let data: [MonthlyCompleteBook]
    
    init(_ data: [MonthlyCompleteBook]) {
        self.data = data
    }
    
    var scrollPositionStart: Date {
        Date(timeIntervalSinceReferenceDate: scrollPosition)
    }
    
    var scrollPositionEnd: Date {
        scrollPositionStart.addingTimeInterval(86400 * 30 * 6)
    }
    
    var scrollPositionStartString: String {
        scrollPositionStart.toFormat("yyyy년 M월")
    }
    
    var scrollPositionEndString: String {
        scrollPositionEnd.toFormat("yyyy년 M월")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Text("일일 독서 페이지")
                    .navigationTitleStyle()
                
                Spacer()
            }
            .overlay {
                navigationBarButtons
            }
            .padding(.vertical)
            
            ZStack {
                Color(.background)
                
                ScrollView {
                    VStack {
                        VStack(alignment: .leading, spacing: -2) {
                            Text("총 완독 권수")
                                .font(.callout.weight(.semibold))
                                .foregroundStyle(Color.secondary)
                            
                            HStack(alignment: .firstTextBaseline) {
                                Text("\(totalReadPagesInPreiod(in: scrollPositionStart...scrollPositionEnd))")
                                    .font(.title.weight(.bold))
                                    .foregroundStyle(Color.blue)
                                Text("권")
                                    .font(.headline)
                                    .foregroundStyle(Color.blue)
                                Spacer()
                            }
                            
                            Text("\(scrollPositionStartString) ~ \(scrollPositionEndString)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Color.secondary)
                        }
                        
                        Chart {
                            ForEach(data, id: \.self) { element in
                                BarMark(
                                    x: .value("date", element.date, unit: .day),
                                    y: .value("page", element.count)
                                )
                                .foregroundStyle(Color.blue)
                            }
                            
                            if isPresentingAverageRuleMark {
                                RuleMark(
                                    y: .value(
                                        "average",
                                        averageReadPagesInPreiod(in: scrollPositionStart...scrollPositionEnd)
                                    )
                                )
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                .foregroundStyle(Color.black)
                                .annotation(position: .top, alignment: .leading) {
                                    Text("일 평균 독서 페이지: \(averageReadPagesInPreiod(in: scrollPositionStart...scrollPositionEnd))")
                                        .font(.headline)
                                        .foregroundStyle(Color.black)
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
                    .padding()
                    .background(Color.white, in: .rect(cornerRadius: 15))
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPresentingAverageRuleMark.toggle()
                        }
                    } label: {
                        HStack {
                            Text("일 평균 독서 페이지")
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("\(averageReadPagesInPreiod(in: scrollPositionStart...scrollPositionEnd))")
                        }
                        .padding()
                        .foregroundColor(isPresentingAverageRuleMark ? Color.white : Color.black)
                        .background(isPresentingAverageRuleMark ? Color.blue : Color.white)
                        .clipShape(.rect(cornerRadius: 20))
                    }
                    .padding(.bottom, 15)
                    
                    Text("세부 정보")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 17)
                        .padding(.bottom, 0)
                    
                    VStack(spacing: 0) {
                        ForEach(data) { item in
                            VStack(spacing: 0) {
                                HStack {
                                    Text(item.date.toFormat("yyyy년 M월"))
                                    
                                    Spacer()
                                    
                                    Text("\(item.count)페이지")
                                        .foregroundStyle(Color.secondary)
                                }
                                .padding(.vertical, 13)
                                .padding(.horizontal)
                                
                                if data.last != item {
                                    Divider()
                                        .padding(.horizontal, 10)
                                        .offset(x: 10)
                                }
                            }
                        }
                    }
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 15))
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding([.leading, .top, .trailing])
                .safeAreaPadding(.bottom, 40)
            }
        }
        .onChange(of: selectedTimeRange, initial: true) { newValue, _ in
            scrollPosition = data.last?.date.addingTimeInterval(-1 * 86400 * 30 * 6).timeIntervalSinceReferenceDate ?? 0.0
        }
        .navigationBarBackButtonHidden()
    }
    
    func totalReadPagesInPreiod(in range: ClosedRange<Date>) -> Int {
        data.filter({ range.contains($0.date) }).reduce(0) { $0 + $1.count }
    }
    
    func averageReadPagesInPreiod(in range: ClosedRange<Date>) -> Int {
        totalReadPagesInPreiod(in: range) / readPagesCountInPeriod(in: range)
    }
    
    func readPagesCountInPeriod(in range: ClosedRange<Date>) -> Int {
        var count: Int = 0
        count = data.filter({ range.contains($0.date) }).count
        return count != 0 ? count : 1
    }
}

extension monthlyCompleteBookChartView {
    var navigationBarButtons: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .navigationBarItemStyle()
            }

            Spacer()
        }
    }
}

#Preview {
    monthlyCompleteBookChartView([])
}
