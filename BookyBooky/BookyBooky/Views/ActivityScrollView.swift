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
    
    @ObservedResults(CompleteBook.self) var readingBooks
    
    @State private var activities: [MonthlyReadingActivity] = []
    
    // MARK: - BODY
    
    var body: some View {
        scrollContent
            .onAppear {
                activities = readingBooks.monthlyReadingActivity
            }
    }
}

// MARK: - EXTENSIONS

extension ActivityScrollView {
    var scrollContent: some View {
        Group {
            if activities.isEmpty {
                noActivitiesLabel
            } else {
                activityScroll
            }
        }
    }
    
    var noActivitiesLabel: some View {
        VStack(spacing: 5) {
            Text("독서 데이터가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("독서 데이터를 추가하십시오.")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var activityScroll: some View {
        ScrollView {
            LazyVStack(spacing: 5, pinnedViews: [.sectionHeaders]) {
                ForEach(activities, id: \.self) { activity in
                    Section {
                        VStack {
                            activitySummaryLabel(activity)
                            
                            activityButtonGroup(activity)
                        }
                    } header: {
                        dateText(activity.month)
                    }
                }
            }
        }
        .padding(.bottom, 40)
    }
    
    func activityButtonGroup(_ activity: MonthlyReadingActivity) -> some View {
        VStack(spacing: 5) {
            ForEach(activity.activities, id: \.self) { activity in
                ActivityCellButton(activity)
            }
        }
        .padding(.bottom, 20)
    }
    
    func dateText(_ date: Date) -> some View {
        Text(date.toFormat("yyyy년 M월"))
            .font(.headline.weight(.bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
            .padding([.bottom, .leading], 15)
            .background(.white)
    }
    
    func activitySummaryLabel(_ activity: MonthlyReadingActivity) -> some View {
        VStack(spacing: 10) {
            readingDayCountLabel(activity)
            
            numOfCompleteReadingLabel(activity)
            
            totalReadPageLabel(activity)
        }
        .padding(.horizontal)
    }
    
    func readingDayCountLabel(_ activity: MonthlyReadingActivity) -> some View {
        HStack {
            Label("독서일", systemImage: "calendar.circle.fill")
                .font(.headline.weight(.bold))
            
            Spacer()
            
            Text("\(activity.readingDayCount)일")
        }
    }
    
    func numOfCompleteReadingLabel(_ activity: MonthlyReadingActivity) -> some View {
        HStack {
            Label("완독한 권수", systemImage: "book.closed.circle.fill")
                .font(.headline.weight(.bold))
            
            Spacer()
            
            Text("\(activity.numOfCompleteReading)권")
                .foregroundColor(Color.purple)
        }
    }
    
    func totalReadPageLabel(_ activity: MonthlyReadingActivity) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Label("읽은 페이지", systemImage: "paperclip.circle.fill")
                .font(.headline.weight(.bold))
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(activity.averageDailyReadingPage)페이지")
                    .foregroundColor(Color.pink)
                
                Text("하루 평균 \(activity.averageDailyReadingPage)페이지")
                    .font(.footnote)
                    .foregroundColor(Color.secondary)
            }
        }
    }
}

// MARK: - PREVIEW

#Preview {
    ActivityScrollView()
        .environmentObject(RealmManager())
}
