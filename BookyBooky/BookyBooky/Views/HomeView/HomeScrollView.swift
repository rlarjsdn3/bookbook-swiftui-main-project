//
//  HomeScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/20.
//

import SwiftUI
import RealmSwift

struct HomeScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var homeViewData: HomeViewData
    @EnvironmentObject var realmManager: RealmManager
    
    // MARK: - BODY
    
    var body: some View {
        homeScrollContent
    }
    
    // MARK: - FUNCTIONS
    
    func getTopBarTitleFontSize(_ scrollYOffset: CGFloat) -> CGFloat {
        let startYOffset = 20.0 // 폰트 크기가 커지기 시작하는 Y축 좌표값
        let endYOffset = 130.0  // 폰트 크기가 최대로 커진 Y축 좌표값
        let scale = 0.03         // Y축 좌표값에 비례하여 커지는 폰트 크기의 배수
        
        let scrollYOffset = -scrollYOffset
        // Y축 좌표가 startYOffset 이상이라면
        if scrollYOffset > startYOffset {
            // Y축 좌표가 endYOffset 미만이라면
            if scrollYOffset < endYOffset {
                return scrollYOffset * scale // 현재 최상단 Y축 좌표의 scale배만큼 추가 사이즈 반환
            // Y축 좌표가 endYOffset 이상이면
            } else {
                return endYOffset * scale // 폰트의 최고 추가 사이즈 반환
            }
        }
        // Y축 좌표가 startYOffset 미만이라면
        return 0.0 // 폰트 추가 사이즈 없음
    }
}

// MARK: - EXTENSION

extension HomeScrollView {
    var homeScrollContent: some View {
        ScrollViewReader { scrollProxy in
            TrackableVerticalScrollView(yOffset: $homeViewData.scrollYOffset) {
                VStack {
                    navigationTopBarTitle
                    
                    HomeActivityTabView()
                    
                    HomeCompleteBookTabView(scrollProxy: scrollProxy)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    var navigationTopBarTitle: some View {
        VStack(alignment: .leading) {
            navigationTopBarSubTitle
            
            navigationTopBarMainTitle
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
    
    var navigationTopBarSubTitle: some View {
        Text(Date().toFormat("M월 d일 E요일"))
            .font(.callout.weight(.semibold))
            .foregroundStyle(Color.secondary)
            .opacity(homeViewData.scrollYOffset > 10 ? 0 : 1)
    }
    
    var navigationTopBarMainTitle: some View {
        Text("홈")
            .font(.system(size: 34.0 /* + getTopBarTitleFontSize(scrollYOffset)*/))
            .fontWeight(.bold)
        //  .minimumScaleFactor(0.001)
        
        // NOTE: - iOS 17부터 하단으로 스크롤 시, 텍스트의 크기가 동적으로 변하지 않게 됨
        //       - 추후, iOS 17 정식 버전 출시 시, 추가 확인이 필요해 보임
    }
}

// MARK: - PREVIEW

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScrollView()
            .environmentObject(HomeViewData())
            .environmentObject(RealmManager())
    }
}
