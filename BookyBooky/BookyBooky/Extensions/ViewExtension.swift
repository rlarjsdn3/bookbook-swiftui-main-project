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
