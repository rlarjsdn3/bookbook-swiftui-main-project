//
//  ColorExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/27.
//

import UIKit
import SwiftUI

extension Color {
    static var customLightGray: Color {
        return Color.gray.opacity(0.08)
    }
    
    static var customDarkGray: Color {
        return Color.gray.opacity(0.2)
    }
    
    static var customBackground: Color {
        return Color("Background")
    }
}
