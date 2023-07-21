//
//  DailyPagesReadChartView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/10/23.
//

import SwiftUI
import Charts

@available(iOS 17.0, *)
struct DailyPagesReadChartView: View {

    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @State private var startOffset: CGFloat = 0.0
    @State private var scrollYOffset: CGFloat = 0.0
    @State private var selectedTimeRange: ChartTimeRange = .last14Days
    @State private var scrollPosition: TimeInterval = 0.0
    @State private var isPresentingAverageRuleMark = false
    
    // MARK: - PROPERTIES
    
    let dailyChartData: [ChartData.DailyPagesRead]
    
    // MARK: - COMPUTED PROPERTIES
    
    var monthlyChartData: [ChartData.DailyPagesRead] {
        var monthlyPages: [ChartData.DailyPagesRead] = []
        
        for daily in dailyChartData {
            if let index = monthlyPages.firstIndex(where: { $0.date.isEqual([.year, .month], date: daily.date) }) {
                monthlyPages[index].pages += daily.pages
            } else {
                monthlyPages.append(
                    ChartData.DailyPagesRead(date: daily.date, pages: daily.pages)
                )
            }
        }
        
        return monthlyPages
    }
    
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
    
    // MARK: - INTIALIZER
    
    init(dailyChartData: [ChartData.DailyPagesRead]) {
        self.dailyChartData = dailyChartData
    }
    
    // MARK: - BODY
    
    var body: some View {
        chartContent
            .onChange(of: selectedTimeRange, initial: true) { _, _  in
                switch selectedTimeRange {
                case .last14Days:
                    scrollPosition = dailyChartData.last?.date.addingTimeInterval(-1 * 86400 * 14).timeIntervalSinceReferenceDate ?? 0.0
                case .last180Days:
                    scrollPosition = dailyChartData.last?.date.addingTimeInterval(-1 * 86400 * 30 * 6).timeIntervalSinceReferenceDate ?? 0.0
                }
            }
            .navigationBarBackButtonHidden()
    }
    
    func totalReadPagesInPreiod(in range: ClosedRange<Date>) -> Int {
        dailyChartData.filter({ range.contains($0.date) }).reduce(0) { $0 + $1.pages }
    }
    
    func averageReadPagesInPreiod(in range: ClosedRange<Date>) -> Int {
        totalReadPagesInPreiod(in: range) / readingDaysCountInPeriod(in: range)
    }
    
    func readingDaysCountInPeriod(in range: ClosedRange<Date>) -> Int {
        var count: Int = 0
        switch selectedTimeRange {
        case .last14Days:
            count = dailyChartData.filter({ range.contains($0.date) }).count
        case .last180Days:
            count = monthlyChartData.filter({ range.contains($0.date) }).count
        }
        return count != 0 ? count : 1
    }
}

// MARK: - EXTENSIONS

@available(iOS 17.0, *)
extension DailyPagesReadChartView {
    var chartContent: some View {
        VStack(spacing: 0) {
            navigationTopBar
                
            ScrollView {
                VStack {
                    chart
                    
                    averageRuleMarkButton
                    
                    recordList
                }
                .trackScrollYOffet($startOffset, yOffset: $scrollYOffset)
            }
            .scrollIndicators(.hidden)
            .safeAreaPadding([.leading, .top, .trailing])
            .safeAreaPadding(.bottom, 40)
            .background(Color(.background))
        }
    }
    
    var navigationTopBar: some View {
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
        .overlay(alignment: .bottom) {
            Divider()
                .opacity(scrollYOffset > 3.0 ? 1 : 0)
        }
    }
    
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
    
    var chart: some View {
        VStack {
            pickTimeRange
            
            chartTitle
            
            barChart
        }
        .padding()
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 15))
    }
    
    var pickTimeRange: some View {
        Picker("", selection: $selectedTimeRange) {
            ForEach(ChartTimeRange.allCases, id: \.self) { range in
                Text(range.name)
                    .tag(range.name)
            }
        }
        .pickerStyle(.segmented)
        .padding(.bottom, 2)
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
    
    var barChart: some View {
        Chart {
            switch selectedTimeRange {
            case .last14Days:
                ForEach(dailyChartData, id: \.self) { element in
                    BarMark(
                        x: .value("date", element.date, unit: .day),
                        y: .value("page", element.pages)
                    )
                    .foregroundStyle(Color.orange)
                }
            case .last180Days:
                ForEach(monthlyChartData, id: \.self) { element in
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
    
    var averageRuleMarkButton: some View {
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
    }
    
    var recordList: some View {
        VStack {
            Text("세부 정보")
                .font(.caption)
                .foregroundStyle(Color.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 17)
                .padding(.bottom, 0)
            
            switch selectedTimeRange {
            case .last14Days:
                VStack(spacing: 0) {
                    ForEach(dailyChartData) { element in
                        VStack(spacing: 0) {
                            HStack {
                                Text(element.date.standardDateFormat)
                                
                                Spacer()
                                
                                Text("\(element.pages)페이지")
                                    .foregroundStyle(Color.secondary)
                            }
                            .padding(.vertical, 13)
                            .padding(.horizontal)
                            
                            if dailyChartData.last != element {
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
                    ForEach(monthlyChartData) { element in
                        VStack(spacing: 0) {
                            HStack {
                                Text(element.date.toFormat("yyyy년 M월"))
                                
                                Spacer()
                                
                                Text("\(element.pages)페이지")
                                    .foregroundStyle(Color.secondary)
                            }
                            .padding(.vertical, 13)
                            .padding(.horizontal)
                            
                            if monthlyChartData.last != element {
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
    }
}

// MARK: - PREVIEW

@available(iOS 17.0, *)
#Preview {
    DailyPagesReadChartView(dailyChartData: [])
}
