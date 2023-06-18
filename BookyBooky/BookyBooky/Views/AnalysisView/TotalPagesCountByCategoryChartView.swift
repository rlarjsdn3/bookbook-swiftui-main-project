//
//  totalPagesReadByCategoryChartView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/10/23.
//

import SwiftUI
import Charts
import RealmSwift

struct TotalPagesCountByCategoryChartView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedResults(CompleteBook.self) var readingBooks
    
    @State private var selectedCategory: Double? = nil
    
    // MARK: - PROPERTIES
    
    let chartData: [TotalPagesReadByCategory]
    let cumulativeSalesRangesForStyles: [(category: String, range: Range<Double>)]
    
    // MARK: - COMPUTED PROPERTIES
    
    var selectedStyle: TotalPagesReadByCategory? {
        if let selectedCategory,
           let selectedIndex = cumulativeSalesRangesForStyles
            .firstIndex(where: { $0.range.contains(selectedCategory) }) {
            return chartData[selectedIndex]
        }
        
        return nil
    }
    
    // MARK: - INTILAIZER

    init(chartData: [TotalPagesReadByCategory]) {
        self.chartData = chartData
        
        var cumulative = 0.0
        self.cumulativeSalesRangesForStyles = chartData.map {
            let newCumulative = cumulative + Double($0.pages)
            let result = (category: $0.category.rawValue, range: cumulative..<newCumulative)
            cumulative = newCumulative
            return result
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Text("분야 별 총 읽은 페이지")
                    .navigationTitleStyle()
                
                Spacer()
            }
            .overlay {
                navigationBarButtons
            }
            .padding(.vertical)
                
            ScrollView {
                Chart(chartData) { element in
                    SectorMark(
                        angle: .value("pages", element.pages),
                        innerRadius: .ratio(0.618),
                        angularInset: 1.5
                    )
                    .cornerRadius(5.0)
                    .opacity(selectedStyle == nil ? 1 : (selectedStyle?.category == element.category ? 1 : 0.3))
                    .foregroundStyle(by: .value("category", element.category.rawValue))
                }
                .chartLegend(alignment: .center, spacing: 18)
                .chartBackground { chartProxy  in
                    GeometryReader { geometry in
                        let frame = geometry[chartProxy.plotAreaFrame]
                        VStack {
                            if let selectedStyle = selectedStyle {
                                Text(selectedStyle.category.name)
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                                Text("\(selectedStyle.pages)페이지")
                                    .font(.callout.weight(.bold))
                                Text("\(pageCountByCategoryRatio(selectedStyle.pages))%")
                                    .font(.caption)
                            } else {
                                VStack {
                                    Text("분야 별")
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                    Text("총 읽은 페이지")
                                        .font(.callout.weight(.bold))
                                }
                            }
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                }
                .chartAngleSelection($selectedCategory)
                .frame(height: 300)
                .padding()
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 15))
                .padding(.bottom, 15)
                
                Text("세부 정보")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 17)
                    .padding(.bottom, 0)
                
                VStack(spacing: 0) {
                    ForEach(chartData) { element in
                        VStack(spacing: 0) {
                            HStack(alignment: .firstTextBaseline, spacing: 3) {
                                Text(element.category.name)
                                
                                Spacer()
                                
                                Text("\(element.pages)페이지")
                                    .foregroundStyle(Color.secondary)
                                
                                Text("(\(pageCountByCategoryRatio(element.pages))%)")
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                            }
                            .padding(.vertical, 13)
                            .padding(.horizontal)
                            
                            if chartData.last != element {
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
            .background(Color(.background))
        }
        .navigationBarBackButtonHidden()
    }
    
    func pageCountByCategoryRatio(_ pageCountByCategory: Int) -> String {
        let pageCount = Double(pageCountByCategory)
        let totalReadPages = Double(chartData.reduce(0, { $0 + $1.pages }))
        let ratio = (pageCount / totalReadPages) * 100.0
        return ratio.formatted(.number.precision(.fractionLength(1)))
    }
}

extension TotalPagesCountByCategoryChartView {
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
    TotalPagesCountByCategoryChartView(chartData: [])
}
