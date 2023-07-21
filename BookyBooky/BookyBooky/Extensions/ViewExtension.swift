//
//  ViewExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import UIKit
import SwiftUI
import Combine

extension View {
    /// 실행 중인 기기의 SafeArea 영역의 크기를 반환합니다.
    var safeAreaInsets: UIEdgeInsets {
        // 코드 수정 필요
        UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 실행 중인 기기의 가로 및 세로 길이를 반환합니다.
    var mainScreen: CGRect {
        UIScreen.main.bounds
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
//            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    /// 키보드를 숨깁니다. (코드 출처: https://url.kr/zsx7m8)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
 
public extension View {
    func modify<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
        transform(self)
    }
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
    func asyncCoverImage(_ url: String,
                    width: CGFloat = 150, height: CGFloat = 200,
                    coverShape: some Shape = RoundedRect()) -> some View {
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
}
