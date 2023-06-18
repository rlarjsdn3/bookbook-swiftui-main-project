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
    
    // MARK: - BODY
    
    var body: some View {
        activityScrollContent
    }
}

// MARK: - EXTENSIONS

extension ActivityScrollView {
    var activityScrollContent: some View {
        Group {
            let activities = readingBooks.monthlyReadingActivity
            
            if activities.isEmpty {
                noActivityLabel
            } else {
                activityScroll(activities)
            }
        }
    }
    
    var noActivityLabel: some View {
        VStack(spacing: 5) {
            Text("독서 데이터가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("독서 데이터를 추가하십시오.")
                .foregroundColor(.secondary)
        }
    }
    
    func activityScroll(_ activities: [MonthlyReadingActivity]) -> some View {
        ScrollView {
            LazyVStack(spacing: 5, pinnedViews: [.sectionHeaders]) {
                ForEach(activities, id: \.self) { activity in
                    Section {
                        VStack {
                            summaryLabel(activity)
                            
                            activityButtonGroup(activity)
                        }
                    } header: {
                        dateHeaderText(activity.month)
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
            
            totalPagesReadLabel(activity)
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
    
    func completeBookCountLabel(_ activity: MonthlyReadingActivity) -> some View {
        HStack {
            Label("완독한 권수", systemImage: "book.closed.circle.fill")
                .font(.headline.weight(.bold))
            
            Spacer()
            
            Text("\(activity.completeBookCount)권")
                .foregroundColor(Color.purple)
        }
    }
    
    func totalPagesReadLabel(_ activity: MonthlyReadingActivity) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Label("읽은 페이지", systemImage: "paperclip.circle.fill")
                .font(.headline.weight(.bold))
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(activity.averagePagesRead)페이지")
                    .foregroundColor(Color.pink)
                
                Text("하루 평균 \(activity.averagePagesRead)페이지")
                    .font(.footnote)
                    .foregroundColor(Color.secondary)
            }
        }
    }
    
    func activityButtonGroup(_ activity: MonthlyReadingActivity) -> some View {
        VStack(spacing: 5) {
            ForEach(activity.readingActivity, id: \.self) { activity in
                ActivityButton(activity)
            }
        }
        .padding(.bottom, 20)
    }
    
    func dateHeaderText(_ date: Date) -> some View {
        Text(date.toFormat("yyyy년 M월"))
            .font(.headline.weight(.bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
            .padding([.bottom, .leading], 15)
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
