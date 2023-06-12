//
//  ReverseIconStyle.swift
//  BookyBooky
//
//  Created by 김건우 on 6/12/23.
//

import SwiftUI

struct ReverseIconStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
    }
}
