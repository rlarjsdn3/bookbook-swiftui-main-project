//
//  totalPagesReadByCategoryChartView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/10/23.
//

import SwiftUI
import Charts
import RealmSwift

// 퍼센티지 비율도 함께 출력하기

struct TotalPagesReadByCategoryChartView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    @State private var selectedCategory: Double? = nil
    
    let totalPagesReadByCategoryData: [TotalPagesReadByCategory]
    let cumulativeSalesRangesForStyles: [(name: String, range: Range<Double>)]
    
    var selectedStyle: TotalPagesReadByCategory? {
        if let selectedCategory,
           let selectedIndex = cumulativeSalesRangesForStyles
            .firstIndex(where: { $0.range.contains(selectedCategory) }) {
            return totalPagesReadByCategoryData[selectedIndex]
        }
        
        return nil
    }

    init(data: [TotalPagesReadByCategory]) {
        self.totalPagesReadByCategoryData = data
        
        var cumulative = 0.0
        self.cumulativeSalesRangesForStyles = totalPagesReadByCategoryData.map {
            let newCumulative = cumulative + Double($0.pages)
            let result = (name: $0.category.rawValue, range: cumulative ..< newCumulative)
            cumulative = newCumulative
            return result
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Text("분류 별 총 읽은 페이지")
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
                    Chart(totalPagesReadByCategoryData) { element in
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
                                    Text(selectedStyle.category.rawValue)
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                    Text("\(selectedStyle.pages)페이지")
                                        .font(.callout.weight(.bold))
                                } else {
                                    VStack {
                                        Text("분류 별")
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
                        ForEach(totalPagesReadByCategoryData) { item in
                            VStack(spacing: 0) {
                                HStack {
                                    Text(item.category.rawValue)
                                    
                                    Spacer()
                                    
                                    Text("\(item.pages)페이지")
                                        .foregroundStyle(Color.secondary)
                                }
                                .padding(.vertical, 13)
                                .padding(.horizontal)
                                
                                if totalPagesReadByCategoryData.last != item {
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
                .safeAreaPadding()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension TotalPagesReadByCategoryChartView {
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
    TotalPagesReadByCategoryChartView(data: [])
}
