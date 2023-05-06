//
//  DateExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/06.
//

import Foundation

extension Date {
    func isFirstMonth() -> Bool {
        let components = Calendar.current.dateComponents([.day], from: self)
        return components.day == 1
    }
}
