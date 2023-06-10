//
//  AnalysisView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/20.
//

import SwiftUI
import RealmSwift
import Charts

struct totalPagesReadByCategory: Identifiable, Hashable {
    var category: CategoryType
    var totalPagesRead: Int
    
    var id: CategoryType { category }
}


struct AnalysisView: View {
    
    @ObservedResults(ReadingBook.self) var readingBooks

    var totalPagesByCategory: [totalPagesReadByCategory] {
        var totalPagesReadByCategory: [totalPagesReadByCategory] = []
        
        for readingBook in readingBooks {
            if let index = totalPagesReadByCategory.firstIndex(where: { $0.category == readingBook.category }) {
                totalPagesReadByCategory[index].totalPagesRead += readingBook.lastRecord?.totalPagesRead ?? 0
            } else {
                totalPagesReadByCategory.append(
                    .init(category: readingBook.category, totalPagesRead: readingBook.lastRecord?.totalPagesRead ?? 0)
                )
            }
        }
        
        return totalPagesReadByCategory
    }
    
    
    
    var body: some View {
        // 헤더뷰 높이 수정
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
                                            x: .value("pages", element.totalPagesRead),
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
                    }
                    .safeAreaPadding()
                }
            }
        }
        .onAppear {
            print(totalPagesByCategory)
        }
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
    }
}
