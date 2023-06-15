//
//  HomeMainActivityView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/17.
//

import SwiftUI
import RealmSwift

struct HomeActivityTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    // MARK: - BODY
    
    var body: some View {
        activityTab
    }
}

// MARK: - EXTENSIONS

extension HomeActivityTabView {
    var activityTab: some View {
        VStack(spacing: 10) {
            activityTabTitle
            
            activityTabContent
        }
    }
    
    var activityTabTitle: some View {
        HStack {
            activityHeadlineText
            
            Spacer()
            
            moreButton
        }
        .padding(.leading, 15)
        .padding(.trailing, 25)
    }
    
    var activityHeadlineText: some View {
        Text("활동")
            .font(.title2)
            .fontWeight(.bold)
    }
    
    var moreButton: some View {
        NavigationLink("더 보기") {
            ActivityView()
        }
        .disabled(readingBooks.isEmpty)
    }
    
    var activityTabContent: some View {
        VStack(spacing: 5) {
            let recentActivities = readingBooks.getRecentReadingActivity()
            
            if recentActivities.isEmpty {
                noActivityLabel
            } else {
                activityButtons(recentActivities)
            }
        }
    }
    
    func activityButtons(_ activities: [ReadingActivity]) -> some View {
        ForEach(activities, id: \.self) { activity in
            ActivityCellButton(activity)
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
        .padding(.vertical, 40)
    }
}

// MARK: - PREVIEW

struct HomeActivityView_Previews: PreviewProvider {
    static var previews: some View {
        HomeActivityTabView()
            .environmentObject(RealmManager())
    }
}
