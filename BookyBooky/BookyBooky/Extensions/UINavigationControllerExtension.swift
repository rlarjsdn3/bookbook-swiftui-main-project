//
//  UINavigationControllerExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/12.
//

import UIKit

/// (코드 출처: https://url.kr/jlx6c7)
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    /// NavigaionStack에서 '뒤로 가기'버튼을 커스텀하더라도, 스와이프 제스처가 동작하도록 하는 함수입니다.
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
