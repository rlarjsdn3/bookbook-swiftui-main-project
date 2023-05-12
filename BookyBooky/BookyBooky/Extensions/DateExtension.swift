//
//  DateExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/06.
//

import Foundation

extension Date {
    /// 사용자가 원하는 형식의 날짜 문자열을 만들어 반환하는 함수입니다.
    func toFormat(_ format: String, locale: Locale = Locale(identifier: "ko_kr")) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = locale
        return dateFormatter.string(from: self)
    }
    
    /// 두 날짜를 주어진 요소(components)에 한하여 비교한 결과값(Boolean)을 반환하는 함수입니다.
    func isEqual(_ components: Set<Calendar.Component>, date: Date) -> Bool {
        let calendar = Calendar.current
        let comp1 = calendar.dateComponents(components, from: self)
        let comp2 = calendar.dateComponents(components, from: date)
        
        for component in components {
            // 두 요소 중 하나라도 동일하지 않다면
            if comp1.value(for: component) != comp2.value(for: component) {
                return false // False 반환
            }
        }
        
        return true // True 반환
    }
}
