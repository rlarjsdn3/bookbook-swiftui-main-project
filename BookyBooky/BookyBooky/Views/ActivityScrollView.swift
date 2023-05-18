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
    
    // MARK: - BODY
    
    var body: some View {
        activityPinnedScroll
    }
}

// MARK: - EXTENSIONS

extension ActivityScrollView {
    var activityPinnedScroll: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                monthlyReadingActivitySection
            }
        }
        .padding(.bottom, 40)
    }
    
    var monthlyReadingActivitySection: some View {
        ForEach(realmManager.getMonthlyReadingActivity(), id: \.self) { monthlyActivity in
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
            
            Text("\(realmManager.getMonthlyReadingDayCount(monthlyActivity))일")
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
                
                Text("하루 평균 \( monthlyActivity.activities.reduce(0, { $0 + $1.numOfPagesRead }) / realmManager.getMonthlyReadingDayCount(monthlyActivity) )페이지")
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
