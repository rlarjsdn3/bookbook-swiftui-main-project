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
    
    @ObservedResults(CompleteBook.self) var compBooks
    
    // MARK: - BODY
    
    var body: some View {
        activityTab
            .onAppear {
                // NOTE: - 이전 방식은 View 내에서 함수를 호출해 직접 활동 데이터를 불러오는(O(n^2)) 방식이었습니다.
                //       - 이로 인해, 콘텐츠 스크롤 시, 좌표 값이 변화됨에 따른 잦은 화면 갱신으로 인한 프레임 저하가 있었습니다.
                //       - 이제는 HomeViewData 내에 활동 데이터를 저장하는 방식으로 변경하였습니다.
                //       - 덕분에, 콘텐츠 스크롤 시, 화면 갱신에 따른 활동 데이터를 불러오는 함수를 호출할 필요가 없어져서
                //       - 성능을 개선시켰습니다. 이제는 화면이 나타날 때 한번만 호출됩니다. (2023. 7. 5)
                
                homeViewData.getActivityData(compBooks)
            }
    }
}

// MARK: - EXTENSIONS

extension HomeActivityTabView {
    var activityTab: some View {
        VStack(spacing: 10) {
            tabTitle
            
            tabContent
        }
    }
    
    var tabTitle: some View {
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
    
    var tabContent: some View {
        VStack(spacing: 5) {            
            if homeViewData.activityData.isEmpty {
                noActivityLabel
            } else {
                activityButtonGroup(homeViewData.activityData)
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
            .environmentObject(HomeViewData())
            .environmentObject(RealmManager())
    }
}
