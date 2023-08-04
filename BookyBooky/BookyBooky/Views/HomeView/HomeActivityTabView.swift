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
    
    @EnvironmentObject var homeViewData: HomeViewData
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(CompleteBook.self) var readingBooks
    
    @State private var activityData: [ReadingActivity] = []
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 10) {
            tabHeader
            
            tabContent
        }
        .onAppear {
            activityData = readingBooks.recentReadingActivity
        }
    }
}

// MARK: - EXTENSIONS

extension HomeActivityTabView {
    var tabHeader: some View {
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
        .disabled(readingBooks.isEmpty)
    }
    
    var tabContent: some View {
        VStack(spacing: 5) {            
            if activityData.isEmpty {
                noActivitiesLabel
            } else {
                activityButtonGroup
            }
        }
    }
    
    var activityButtonGroup: some View {
        ForEach(activityData, id: \.self) { activity in
            ActivityCellButton(activity)
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
        .padding(.vertical, 40)
    }
}

// MARK: - PREVIEW

struct HomeActivityView_Previews: PreviewProvider {
    static var previews: some View {
        HomeActivityTabView()
            .environmentObject(HomeViewData())
            .environmentObject(RealmManager())
    }
}
