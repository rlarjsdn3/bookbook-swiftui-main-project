//
//  DailyPagesReadChartView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/10/23.
//

import SwiftUI
import Charts

enum TimeRange: String, CaseIterable {
    case last14Days = "2주"
    case last180Days = "6개월"
}

struct DailyPagesReadChartView: View {

    @Environment(\.dismiss) var dismiss
    
    @State private var selectedTimeRange: TimeRange = .last14Days
    
    @State private var scrollPosition: TimeInterval = 0.0
    @State private var isPresentingAverageRuleMark = false
    
    
    var scrollPositionStart: Date {
        Date(timeIntervalSinceReferenceDate: scrollPosition)
    }
    
    var dailyScrollPositionEnd: Date {
        scrollPositionStart.addingTimeInterval(86400 * 14)
    }
    
    var monthlyScrollPositionEnd: Date {
        scrollPositionStart.addingTimeInterval(86400 * 30 * 6)
    }
    
    var dailyScrollPositionStartString: String {
        scrollPositionStart.standardDateFormat
    }
    
    var dailyScrollPositionEndString: String {
        dailyScrollPositionEnd.toFormat("M월 d일 (E)")
    }
    
    var monthlyScrollPositionStartString: String {
        scrollPositionStart.toFormat("yyyy년 M월")
    }
    
    var monthlyScrollPositionEndString: String {
        monthlyScrollPositionEnd.toFormat("yyyy년 M월")
    }
    
    
    let daily: [DailyPagesRead]
    let monthly: [DailyPagesRead]
    
    init(daily: [DailyPagesRead], monthly: [DailyPagesRead]) {
        self.daily = daily
        self.monthly = monthly
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
                        Picker("", selection: $selectedTimeRange) {
                            ForEach(TimeRange.allCases, id: \.self) { range in
                                Text(range.rawValue)
                                    .tag(range.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.bottom, 2)
                        
                        chartTitle
                        
                        Chart {
                            switch selectedTimeRange {
                            case .last14Days:
                                ForEach(daily, id: \.self) { element in
                                    BarMark(
                                        x: .value("date", element.date, unit: .day),
                                        y: .value("page", element.pages)
                                    )
                                    .foregroundStyle(Color.orange)
                                }
                            case .last180Days:
                                ForEach(monthly, id: \.self) { element in
                                    BarMark(
                                        x: .value("date", element.date, unit: .month),
                                        y: .value("page", element.pages)
                                    )
                                    .foregroundStyle(Color.orange)
                                }
                            }
                            
                            if isPresentingAverageRuleMark {
                                switch selectedTimeRange {
                                case .last14Days:
                                    RuleMark(
                                        y: .value(
                                            "average",
                                            averageReadPagesInPreiod(in: scrollPositionStart...dailyScrollPositionEnd)
                                        )
                                    )
                                    .lineStyle(StrokeStyle(lineWidth: 3))
                                    .foregroundStyle(Color.black)
                                    .annotation(position: .top, alignment: .leading) {
                                        Text("일 평균 독서 페이지: \(averageReadPagesInPreiod(in: scrollPositionStart...dailyScrollPositionEnd))")
                                            .font(.headline)
                                            .foregroundStyle(Color.black)
                                    }
                                case .last180Days:
                                    RuleMark(
                                        y: .value(
                                            "average",
                                            averageReadPagesInPreiod(in: scrollPositionStart...monthlyScrollPositionEnd)
                                        )
                                    )
                                    .lineStyle(StrokeStyle(lineWidth: 3))
                                    .foregroundStyle(Color.black)
                                    .annotation(position: .top, alignment: .leading) {
                                        Text("일 평균 독서 페이지: \(averageReadPagesInPreiod(in: scrollPositionStart...monthlyScrollPositionEnd))")
                                            .font(.headline)
                                            .foregroundStyle(Color.black)
                                    }
                                }
                            }
                        }
                        .chartScrollableAxes(.horizontal)
                        .chartXVisibleDomain(
                            length: selectedTimeRange == .last14Days ? 86400 * 14 : 86400 * 30 * 6
                        )
                        .chartScrollTargetBehavior(
                            .valueAligned(
                                matching: DateComponents(hour: 0),
                                majorAlignment: .matching(.init(day: 1))
                            )
                        )
                        .chartScrollPosition(x: $scrollPosition)
                        .chartXAxis {
                            switch selectedTimeRange {
                            case .last14Days:
                                AxisMarks(values: .stride(by: .day, count: 7)) {
                                    AxisTick()
                                    AxisGridLine()
                                    AxisValueLabel(format: .dateTime.month().day())
                                }
                            case .last180Days:
                                AxisMarks(values: .stride(by: .month)) {
                                    AxisTick()
                                    AxisGridLine()
                                    AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                                }
                            }
                        }
                        .frame(height: 300)
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 15))
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPresentingAverageRuleMark.toggle()
                        }
                    } label: {
                        HStack {
                            Text("일 평균 독서 페이지")
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            switch selectedTimeRange {
                            case .last14Days:
                                Text("\(averageReadPagesInPreiod(in: scrollPositionStart...dailyScrollPositionEnd))")
                            case .last180Days:
                                Text("\(averageReadPagesInPreiod(in: scrollPositionStart...monthlyScrollPositionEnd))")
                            }
                        }
                        .padding()
                        .foregroundColor(isPresentingAverageRuleMark ? Color.white : Color.black)
                        .background(isPresentingAverageRuleMark ? Color.orange : Color.white)
                        .clipShape(.rect(cornerRadius: 20))
                    }
                    .padding(.bottom, 15)
                    
                    Text("세부 정보")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 17)
                        .padding(.bottom, 0)
                    
                    switch selectedTimeRange {
                    case .last14Days:
                        VStack(spacing: 0) {
                            ForEach(daily) { item in
                                VStack(spacing: 0) {
                                    HStack {
                                        Text(item.date.standardDateFormat)
                                        
                                        Spacer()
                                        
                                        Text("\(item.pages)페이지")
                                            .foregroundStyle(Color.secondary)
                                    }
                                    .padding(.vertical, 13)
                                    .padding(.horizontal)
                                    
                                    if daily.last != item {
                                        Divider()
                                            .padding(.horizontal, 10)
                                            .offset(x: 10)
                                    }
                                }
                            }
                        }
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 15))
                    case .last180Days:
                        VStack(spacing: 0) {
                            ForEach(monthly) { item in
                                VStack(spacing: 0) {
                                    HStack {
                                        Text(item.date.toFormat("yyyy년 M월"))
                                        
                                        Spacer()
                                        
                                        Text("\(item.pages)페이지")
                                            .foregroundStyle(Color.secondary)
                                    }
                                    .padding(.vertical, 13)
                                    .padding(.horizontal)
                                    
                                    if monthly.last != item {
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
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding()
            }
        }
        .onChange(of: selectedTimeRange, initial: true) { newValue, _ in
            switch selectedTimeRange {
            case .last14Days:
                scrollPosition = daily.last?.date.addingTimeInterval(-1 * 86400 * 14).timeIntervalSinceReferenceDate ?? 0.0
            case .last180Days:
                scrollPosition = daily.last?.date.addingTimeInterval(-1 * 86400 * 30 * 6).timeIntervalSinceReferenceDate ?? 0.0
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    func totalReadPagesInPreiod(in range: ClosedRange<Date>) -> Int {
        daily.filter({ range.contains($0.date) }).reduce(0) { $0 + $1.pages }
    }
    
    func averageReadPagesInPreiod(in range: ClosedRange<Date>) -> Int {
        totalReadPagesInPreiod(in: range) / readPagesCountInPeriod(in: range)
    }
    
    func readPagesCountInPeriod(in range: ClosedRange<Date>) -> Int {
        var count: Int = 0
        switch selectedTimeRange {
        case .last14Days:
            count = daily.filter({ range.contains($0.date) }).count
        case .last180Days:
            count = monthly.filter({ range.contains($0.date) }).count
        }
        return count != 0 ? count : 1
    }
}

extension DailyPagesReadChartView {
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
    
    var chartTitle: some View {
        Group {
            switch selectedTimeRange {
            case .last14Days:
                VStack(alignment: .leading, spacing: -2) {
                    Text("총 읽은 페이지")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(Color.secondary)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(totalReadPagesInPreiod(in: scrollPositionStart...dailyScrollPositionEnd))")
                            .font(.title.weight(.bold))
                        Text("페이지")
                            .font(.headline)
                        Spacer()
                    }
                    
                    Text("\(dailyScrollPositionStartString) ~ \(dailyScrollPositionEndString)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.secondary)
                }
            case .last180Days:
                VStack(alignment: .leading, spacing: -2) {
                    Text("총 읽은 페이지")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(Color.secondary)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(totalReadPagesInPreiod(in: scrollPositionStart...monthlyScrollPositionEnd))")
                            .font(.title.weight(.bold))
                        Text("페이지")
                            .font(.headline)
                        Spacer()
                    }
                    
                    Text("\(monthlyScrollPositionStartString) ~ \(monthlyScrollPositionEndString)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.secondary)
                }
            }
        }
    }
}

#Preview {
    DailyPagesReadChartView(daily: [], monthly: [])
}
