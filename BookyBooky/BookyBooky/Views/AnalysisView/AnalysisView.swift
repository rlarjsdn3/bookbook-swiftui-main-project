//
//  AnalysisView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/20.
//

import SwiftUI
import RealmSwift
import Charts

struct TotalPagesReadByCategory: Identifiable, Hashable {
    var category: CategoryType
    var pages: Int
    
    var id: CategoryType { category }
}

struct DailyPagesRead: Identifiable, Hashable {
    var date: Date
    var pages: Int
    
    var id: Date { date }
}


struct AnalysisView: View {
    
    @ObservedResults(ReadingBook.self) var readingBooks

    var totalPagesByCategory: [TotalPagesReadByCategory] {
        var totalPagesReadByCategory: [TotalPagesReadByCategory] = []
        
        for readingBook in readingBooks {
            if let index = totalPagesReadByCategory.firstIndex(where: { $0.category == readingBook.category }) {
                totalPagesReadByCategory[index].pages += readingBook.lastRecord?.totalPagesRead ?? 0
            } else {
                if let last = readingBook.lastRecord {
                    totalPagesReadByCategory.append(
                        .init(category: readingBook.category, pages: last.totalPagesRead)
                    )
                }
            }
        }
        
        return totalPagesReadByCategory.sorted { $0.pages > $1.pages }
    }
    
    var dailyPages: [DailyPagesRead] {
        var dailyPages: [DailyPagesRead] = []
        
        for readingBook in readingBooks {
            for record in readingBook.readingRecords {
                if let index = dailyPages.firstIndex(where: { $0.date.isEqual([.year, .month, .day], date: record.date) }) {
                    dailyPages[index].pages += record.numOfPagesRead
                } else {
                    dailyPages.append(
                        DailyPagesRead(date: record.date, pages: record.numOfPagesRead)
                    )
                }
            }
        }
        
        return dailyPages
    }
    
    var monthlyPages: [DailyPagesRead] {
        var monthlyPages: [DailyPagesRead] = []
        
        for readingBook in readingBooks {
            for record in readingBook.readingRecords {
                if let index = monthlyPages.firstIndex(where: { $0.date.isEqual([.year, .month], date: record.date) }) {
                    monthlyPages[index].pages += record.numOfPagesRead
                } else {
                    monthlyPages.append(
                        DailyPagesRead(date: record.date, pages: record.numOfPagesRead)
                    )
                }
            }
        }
        
        return monthlyPages
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Text("분석")
                        .navigationTitleStyle()
                    
                    Spacer()
                }
                .padding(.vertical)
                
                ZStack {
                    Color(.background)
                    
                    ScrollView {
                        
                        // 구분선: - 분류 별 독서 현황 파이 차트
                        
                        NavigationLink {
                            TotalPagesReadByCategoryChartView(data: totalPagesByCategory)
                        } label: {
                            VStack {
                                HStack(alignment: .firstTextBaseline) {
                                    Label("분류 별 읽은 총 페이지", systemImage: "book")
                                        .font(.headline)
                                        .foregroundStyle(Color.black)
                                    
                                    Spacer()
                                    
                                    Group {
                                        Text("자세히 보기")
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(Color.secondary)
                                }
                                
                                if totalPagesByCategory.isEmpty {
                                    VStack(spacing: 3) {
                                        Text("차트를 표시할 수 없음")
                                            .font(.headline)
                                        
                                        Text("독서를 시작해보세요.")
                                            .font(.subheadline)
                                            .foregroundStyle(Color.secondary)
                                    }
                                    .padding()
                                } else {
                                    Chart(totalPagesByCategory, id: \.self) { element in
                                        BarMark(
                                            x: .value("pages", element.pages),
                                            stacking: .normalized
                                        )
                                        .foregroundStyle(by: .value("category", element.category.rawValue))
                                    }
                                    .frame(height: 50)
                                    .padding(5)
                                }
                            }
                            .padding(.vertical, 15)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .clipShape(.rect(cornerRadius: 10))
                        }
                        .disabled(totalPagesByCategory.isEmpty ? true : false)
                        .buttonStyle(.plain)
                        
                        // 구분선 - 일일 독서 페이지 막대 그래프
                        
                        NavigationLink {
                            DailyPagesReadChartView(daily: dailyPages, monthly: monthlyPages)
                        } label: {
                            VStack {
                                HStack(alignment: .firstTextBaseline) {
                                    Label("일일 독서 페이지", systemImage: "book")
                                        .font(.headline)
                                        .foregroundStyle(Color.black)
                                    
                                    Spacer()
                                    
                                    Group {
                                        Text("자세히 보기")
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(Color.secondary)
                                }
                                
                                if totalPagesByCategory.isEmpty {
                                    VStack(spacing: 3) {
                                        Text("차트를 표시할 수 없음")
                                            .font(.headline)
                                        
                                        Text("독서를 시작해보세요.")
                                            .font(.subheadline)
                                            .foregroundStyle(Color.secondary)
                                    }
                                    .padding()
                                } else {
                                    Chart(dailyPages, id: \.self) { element in
                                        BarMark(
                                            x: .value("date", element.date, unit: .day),
                                            y: .value("pages", element.pages)
                                        )
                                        .cornerRadius(5.0)
                                        .foregroundStyle(element.date.isEqual([.year, .month, .day], date: Date()) ? Color.orange : Color.gray)
                                    }
                                    .chartXAxis(.hidden)
                                    .chartYAxis(.hidden)
                                    .chartXScale(domain: Date().addingTimeInterval(-14*86400)...Date())
                                    .frame(height: 50)
                                    .padding(5)
                                }
                            }
                            .padding(.vertical, 15)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .clipShape(.rect(cornerRadius: 10))
                        }
                        .disabled(totalPagesByCategory.isEmpty ? true : false)
                        .buttonStyle(.plain)
                        
                        
                        
                    }
                    .safeAreaPadding()
                }
            }
        }
        .onAppear {
            print(totalPagesByCategory)
            print(dailyPages)
        }
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
    }
}
