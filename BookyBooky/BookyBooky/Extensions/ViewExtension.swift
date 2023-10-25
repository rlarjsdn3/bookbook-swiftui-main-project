//
//  ViewExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import UIKit
import SwiftUI
import Combine
import Shimmer
import Kingfisher

extension View {
    // 실행 중인 기기의 가로 및 세로 길이 정보를 반환합니다.
    var mainScreen: CGRect {
        UIScreen.main.bounds
    }
    
    /// 실행 중인 기기의 SafeArea 영역 정보를 반환합니다.
    var safeAreaInsets: UIEdgeInsets {
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 키보드의 표시 유무를 뷰에 알려줍니다. (코드 출처: https://url.kr/qnl2ws)
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .Merge(
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .map { _ in true },
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false })
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    /// 키보드를 숨깁니다. (코드 출처: https://url.kr/zsx7m8)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    
    ///  첫 번째 매개변수로 주어진 이미지 URL에 담긴 이미지를 불러와 반환하는 함수입니다. 해당 작업은 비동기적으로 처리됩니다.
    /// - Parameters:
    ///   - url: 이미지 URL
    ///   - width: 이미지 너비 (기본값: 150)
    ///   - height: 이미지 높이 (기본값: 200)
    ///   - coverShape: 이미지 모양 (기본값: 둥근 직사각형 )
    /// - Returns: 뷰(View) 프로토콜을 준수하는 타입
    func kingFisherCoverImage(_ url: String,
                         width: CGFloat = 150, height: CGFloat = 200,
                         coverShape: some Shape = RoundedRect(byRoundingCorners: [.allCorners])) -> some View {
        KFImage(URL(string: url))
            .placeholder { _ in
                Color.gray.opacity(0.2)
                    .frame(width: width, height: height)
                    .clipShape(coverShape)
                    .shimmering()
            }
            .fade(duration: 0.25)
            .retry(maxCount: 3, interval: .seconds(3))
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipShape(coverShape)
            .shadow(color: .black.opacity(0.2), radius: 8, x: -5, y: 5)
    }
}
