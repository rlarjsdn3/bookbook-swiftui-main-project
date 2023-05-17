//
//  ViewExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import UIKit
import SwiftUI

extension View {
    /// 실행 중인 기기의 SafeArea 영역의 크기를 반환합니다.
    var safeAreaInsets: UIEdgeInsets {
        UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 실행 중인 기기의 가로 및 세로 길이를 반환합니다.
    var mainScreen: CGRect {
        UIScreen.main.bounds
    }
    
    /// 키보드를 숨깁니다. (코드 출처: https://url.kr/zsx7m8)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
 
extension View {
    
}

extension View {
    
    ///  매개변수로 주어진 이미지 URL의 이미지를 비동기적으로 불러와 이미지를 반환하는 함수입니다. 기본적으로 너비는 150, 높이는 200 크기의 이미지를 반환합니다.
    ///  이미지를 불러오는 중이거나 불러오는 데 실패하면, 회색 로딩 이미지가 출력됩니다.
    /// - Parameters:
    ///   - url: 이미지 URL
    ///   - width: 이미지 너비
    ///   - height: 이미지 높이
    ///   - coverShape: 이미지 모양
    /// - Returns: 이미지(Image)
    func asyncImage(_ url: String,
                    width: CGFloat = 150, height: CGFloat = 200,
                    coverShape: some Shape) -> some View {
        AsyncImage(url: URL(string: url),
                   transaction: Transaction(animation: .default)
        ) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(coverShape)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: -5, y: 5)
            case .failure(_), .empty:
                loadingImage(width: width, height: height, coverShape: coverShape)
            @unknown default:
                loadingImage(width: width, height: height, coverShape: coverShape)
            }
        }
    }
    
    
    /// 이미지 URL의 이미지를 불러오는 중이거나 불러오는 데 실패하면, 매개변수로 주어진 크기와 모양의 회색 로딩 이미지를 반환합니다.
    /// - Parameters:
    ///   - width: 이미지 너비
    ///   - height: 이미지 높이
    ///   - coverShape: 이미지 모양
    /// - Returns: 색상(Color)
    func loadingImage(width: CGFloat, height: CGFloat, coverShape: some Shape) -> some View {
        Color.gray.opacity(0.2)
            .frame(width: width, height: height)
            .clipShape(coverShape)
            .shimmering()
    }
    
    /// 스크롤의 최상단 Y축 좌표의 위치에 따라 폰트의 추가 사이즈를 반환하는 함수입니다.
    func getNavigationTitleFontSizeOffset(_ scrollYOffset: Double) -> CGFloat {
        let START_yOFFSET = 20.0 // 폰트 크기가 커지기 시작하는 Y축 좌표값
        let END_yOFFSET = 130.0  // 폰트 크기가 최대로 커진 Y축 좌표값
        let SCALE = 0.03         // Y축 좌표값에 비례하여 커지는 폰트 크기의 배수
        
        // Y축 좌표가 START_yOFFSET 이상이라면
        if -scrollYOffset > START_yOFFSET {
            // Y축 좌표가 END_yOFFSET 미만이라면
            if -scrollYOffset < END_yOFFSET {
                return -scrollYOffset * SCALE // 현재 최상단 Y축 좌표의 SCALE배만큼 추가 사이즈 반환
            // Y축 좌표가 END_yOFFSET 이상이면
            } else {
                return END_yOFFSET * SCALE // 폰트의 최고 추가 사이즈 반환
            }
        }
        // Y축 좌표가 START_yOFFSET 미만이라면
        return 0.0 // 폰트 추가 사이즈 없음
    }
}

extension View {
    func navigationBarItemStyle() -> some View {
        modifier(NavigationBarItemStyle())
    }
    
    func navigationTitleStyle() -> some View {
        modifier(NavigationTitleStyle())
    }
}
