//
//  ViewExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import UIKit
import SwiftUI

extension View {
    var safeAreaInsets: UIEdgeInsets {
        UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
