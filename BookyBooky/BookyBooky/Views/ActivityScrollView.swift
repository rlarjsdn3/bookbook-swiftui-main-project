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
    
    var monthlyReadingActivity: [MonthlyReadingActivity] {
        return readingBooks.getMonthlyReadingActivity()
    }
    
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
            let monthlyReadingActivity = monthlyReadingActivity
            
            if monthlyReadingActivity.isEmpty {
                noReadingDataLabel
            } else {
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        monthlyReadingActivitySection
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    var noReadingDataLabel: some View {
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
    
    var monthlyReadingActivitySection: some View {
        ForEach(readingBooks.getMonthlyReadingActivity(), id: \.self) { monthlyActivity in
            Section {
                monthlySummaryLabel(monthlyActivity)
                
                activityCellButtons(monthlyActivity)
            } header: {
                dateText(monthlyActivity)
            }
        }
    }
    
    func monthlySummaryLabel(_ monthlyActivity: MonthlyReadingActivity) -> some View {
        VStack(spacing: 10) {
            readingDayCountLabel(monthlyActivity)
            
            completeBookCountLabel(monthlyActivity)
            
            monthlyTotalReadPagesLabel(monthlyActivity)
        }
        .padding(.horizontal)
    }
    
    func readingDayCountLabel(_ monthlyActivity: MonthlyReadingActivity) -> some View {
        HStack {
            Label("독서일", systemImage: "calendar.circle.fill")
                .font(.headline.weight(.bold))
            
            Spacer()
            
            Text("\(getMonthlyReadingDayCount(monthlyActivity))일")
        }
    }
    
    func completeBookCountLabel(_ monthlyActivity: MonthlyReadingActivity) -> some View {
        HStack {
            Label("완독한 권수", systemImage: "book.closed.circle.fill")
                .font(.headline.weight(.bold))
            
            Spacer()
            
            Text("\(monthlyActivity.activities.reduce(0, { $1.itemPage == $1.totalPagesRead ? $0 + 1 : $0 }))권")
                .foregroundColor(Color.purple)
        }
    }
    
    func monthlyTotalReadPagesLabel(_ monthlyActivity: MonthlyReadingActivity) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Label("읽은 페이지", systemImage: "paperclip.circle.fill")
                .font(.headline.weight(.bold))
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(monthlyActivity.activities.reduce(0, { $0 + $1.numOfPagesRead }))페이지")
                    .foregroundColor(Color.pink)
                
                Text("하루 평균 \( monthlyActivity.activities.reduce(0, { $0 + $1.numOfPagesRead }) / getMonthlyReadingDayCount(monthlyActivity) )페이지")
                    .font(.footnote)
                    .foregroundColor(Color.secondary)
            }
        }
    }
    
    func activityCellButtons(_ monthlyActivity: MonthlyReadingActivity) -> some View {
        ForEach(monthlyActivity.activities, id: \.self) { activity in
            ActivityCellButton(activity)
        }
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
