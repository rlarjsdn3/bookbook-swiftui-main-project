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
                Picker(selection: $selectedDateRange) {
                    ForEach(AnalysisDateRangeTabItems.allCases, id: \.self) { item in
                        Text(item.name)
                    }
                } label: {
                    Text("Label")
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 10)
                .padding(.horizontal)
                
                // 차트 미완성
                Text("Charts Area")
                    .font(.title.weight(.light))
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .padding()
                    .background(Color("Background"))
                    .cornerRadius(20)
                    .padding([.horizontal, .bottom])
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
            AllReadingDatailView(readingBook: readingBook)
        }
    }
}

struct ReadingBookAnalysisView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        ReadingBookAnalysisView(readingBook: readingBooks[0])
    }
}
