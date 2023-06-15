//
//  ActivityScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/18.
//

import SwiftUI
import RealmSwift

struct ActivityScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    // MARK: - BODY
    
    var body: some View {
        activityPinnedScroll
    }
    
    /// <#Description#>
    /// - Parameter activity: <#activity description#>
    /// - Returns: <#description#>
    func getMonthlyReadingDayCount(_ activity: MonthlyReadingActivity) -> Int {
        var dates: [Date] = []
        
        for activity in activity.activities {
            let date = activity.date
            
            if !dates.contains(where: { $0.isEqual([.year, .month, .day], date: date) }) {
                dates.append(date)
            }
        }
        return dates.count
    }
}

// MARK: - EXTENSIONS

extension ActivityScrollView {
    var activityPinnedScroll: some View {
        Group {
            let monthlyActivity = readingBooks.getMonthlyReadingActivity()
            
            if monthlyActivity.isEmpty {
                noActivityLabel
            } else {
                monthlyActivityScrollContent(monthlyActivity)
            }
        }
    }
    
    var noActivityLabel: some View {
        VStack(spacing: 5) {
            Spacer()
            
            Text("독서 데이터가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("독서 데이터를 추가하십시오.")
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 30)
    }
    
    func monthlyActivityScrollContent(_ activities: [MonthlyReadingActivity]) -> some View {
        ScrollView {
            LazyVStack(spacing: 5, pinnedViews: [.sectionHeaders]) {
                ForEach(activities, id: \.self) { activity in
                    Section {
                        VStack {
                            summaryLabel(activity)
                            
                            activityButtons(activity)
                        }
                    } header: {
                        dateText(activity)
                    }
                }
            }
        }
        .safeAreaPadding(.bottom, 40)
    }
    
    func summaryLabel(_ activity: MonthlyReadingActivity) -> some View {
        VStack(spacing: 10) {
            readingDayCountLabel(activity)
            
            completeBookCountLabel(activity)
            
            monthlyTotalReadPagesLabel(activity)
        }
        .padding(.horizontal)
    }
    
    func readingDayCountLabel(_ activity: MonthlyReadingActivity) -> some View {
        HStack {
            Label("독서일", systemImage: "calendar.circle.fill")
                .font(.headline.weight(.bold))
            
            Spacer()
            
            Text("\(getMonthlyReadingDayCount(activity))일")
        }
    }
    
    func completeBookCountLabel(_ activity: MonthlyReadingActivity) -> some View {
        HStack {
            Label("완독한 권수", systemImage: "book.closed.circle.fill")
                .font(.headline.weight(.bold))
            
            Spacer()
            
            Text("\(activity.activities.reduce(0, { $1.isComplete ? $0 + 1 : $0 }))권")
                .foregroundColor(Color.purple)
        }
    }
    
    func monthlyTotalReadPagesLabel(_ activity: MonthlyReadingActivity) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Label("읽은 페이지", systemImage: "paperclip.circle.fill")
                .font(.headline.weight(.bold))
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(activity.activities.reduce(0, { $0 + $1.numOfPagesRead }))페이지")
                    .foregroundColor(Color.pink)
                
                Text("하루 평균 \( activity.activities.reduce(0, { $0 + $1.numOfPagesRead }) / getMonthlyReadingDayCount(activity) )페이지")
                    .font(.footnote)
                    .foregroundColor(Color.secondary)
            }
        }
    }
    
    func activityButtons(_ monthlyActivity: MonthlyReadingActivity) -> some View {
        VStack(spacing: 5) {
            ForEach(monthlyActivity.activities, id: \.self) { activity in
                ActivityButton(activity)
            }
        }
        .padding(.bottom, 20)
    }
    
    func dateText(_ monthlyActivity: MonthlyReadingActivity) -> some View {
        Text(monthlyActivity.date.toFormat("yyyy년 M월"))
            .font(.headline.weight(.bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
            .padding(.bottom, 5)
            .padding(.leading, 15)
            .background(.white)
    }
}

// MARK: - PREVIEW

struct ActivityScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityScrollView()
            .environmentObject(RealmManager())
    }
}
