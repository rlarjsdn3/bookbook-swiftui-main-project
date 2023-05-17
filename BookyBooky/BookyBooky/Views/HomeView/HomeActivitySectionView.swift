//
//  HomeMainActivityView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/17.
//

import SwiftUI

struct HomeActivitySectionView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    // MARK: - BODY
    
    var body: some View {
        activityTab
    }
}

// MARK: - EXTENSIONS

extension HomeActivitySectionView {
    var activityTab: some View {
        VStack {
            activityTabTitle
            
            activityTabMain
        }
    }
    
    var activityTabTitle: some View {
        HStack {
            activityHeadlineText
            
            Spacer()
            
            moreActivityInformationButton
        }
        .padding(.leading, 15)
        .padding(.trailing, 25)
    }
    
    var activityHeadlineText: some View {
        Text("활동")
            .font(.title2)
            .fontWeight(.bold)
    }
    
    var moreActivityInformationButton: some View {
        NavigationLink("더 보기") {
            ActivityView()
        }
        .disabled(realmManager.getRecentReadingActivity().isEmpty)
    }
    
    var activityTabMain: some View {
        VStack {
            let activities = realmManager.getRecentReadingActivity()
            
            if !activities.isEmpty {
                activityCellButtons(activities)
            } else {
                noReadingDataLabel
            }
        }
        .padding(.bottom, 10)
    }
    
    func activityCellButtons(_ activities: [Activity]) -> some View {
        ForEach(activities, id: \.self) { activity in
            ActivityCellButton(activity)
        }
    }
    
    var noReadingDataLabel: some View {
        VStack(spacing: 5) {
            Text("독서 데이터가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("독서 데이터를 추가하십시오.")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 30)
    }
}

// MARK: - PREVIEW

struct HomeMainActivityView_Previews: PreviewProvider {
    static var previews: some View {
        HomeActivitySectionView()
            .environmentObject(RealmManager())
    }
}
