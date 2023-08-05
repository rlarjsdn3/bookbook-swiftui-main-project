//
//  DateExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/06.
//

import Foundation

extension Date {
    /// 가장 일반적인 형식의 날짜 문자열을 만들어 반환하는 함수입니다.
    var standardDateFormat: String {
        self.formatted(
            .dateTime.year().month().day().weekday().locale(Locale(identifier: "ko_kr"))
        )
    }
    
    /// 가장 일반적인 형식의 시간 문자열을 만들어 반환하는 함수입니다.
    var standardTimeFormat: String {
        self.formatted(
            .dateTime.hour().minute().locale(Locale(identifier: "ko_kr"))
        )
    }
    
    /// 첫 번쨰 매개변수로 주어진 형식의 날짜 문자열을 만들어 반환하는 함수입니다.
    /// - Parameter format: 날짜 문자열 형식
    /// - Returns: 문자열(String)
    func toFormat(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: self)
    }
    
    /// 주어진 일수(day)만큼 날짜를 더한 결과를 반환하는 반수입니다.
    /// - Parameter day: 더할 일수(day)
    /// - Returns: 일수를 더한 새로운 날짜(Date)
    func addingDay(_ day: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: day, to: self) ?? Date()
    }
    
    /// 두 날짜를 주어진 요소(components)에 한하여 비교한 결과값을 반환하는 함수입니다.
    /// - Parameters:
    ///   - components: 비교할 날짜 요소
    ///   - date: 비교할 날짜(Date)
    /// - Returns: 동일하면 true, 다르면 false
    func isEqual(_ components: Set<Calendar.Component>, with date: Date) -> Bool {
        let calendar = Calendar.current
        let comp1 = calendar.dateComponents(components, from: self)
        let comp2 = calendar.dateComponents(components, from: date)
        
        for component in components {
            // 두 요소 중 하나라도 동일하지 않다면
            if comp1.value(for: component) != comp2.value(for: component) {
                return false
            }
        }
        
        return true
    }
    
    // 두 날짜 사이의 일수(day) 간격을 반환하는 함수입니다.
    /// - Parameter date: 간격 계산을 위한 두 번째 날짜(Date)
    /// - Returns: 두 날짜 사이의 일수 간격
    func getDayInterval(to date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: self, to: date).day! + 1
    }
}
