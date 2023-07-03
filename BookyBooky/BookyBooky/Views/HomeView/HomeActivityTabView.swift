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
    
    @ObservedResults(CompleteBook.self) var compBooks
    
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
            headlineText
            
            Spacer()
            
            moreButton
        }
        .padding(.leading, 15)
        .padding(.trailing, 25)
    }
    
    var headlineText: some View {
        Text("활동")
            .font(.title2)
            .fontWeight(.bold)
    }
    
    var moreButton: some View {
        NavigationLink("더 보기") {
            ActivityView()
        }
        .disabled(compBooks.isEmpty)
    }
    
    var activityTabContent: some View {
        VStack(spacing: 5) {
            // NOTE: - 최근 활동 기록을 불러오는 중 시간 복잡도가 O(n2)이라 스크롤 시 프레임이 끊김.
            //      - 매 스크롤 시, yOffset을 새로 가져오는 과정에서 화면이 새로 렌더링되기 때문... 
            let recentActivities = compBooks.recentReadingActivity
            
            if recentActivities.isEmpty {
                noActivityLabel
            } else {
                activityButtonGroup(recentActivities)
            }
        }
    }
    
    func activityButtonGroup(_ activities: [ReadingActivity]) -> some View {
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
