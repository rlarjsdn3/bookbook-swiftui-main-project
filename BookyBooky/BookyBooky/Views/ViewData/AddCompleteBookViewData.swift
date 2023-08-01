//
//  AddCompleteBookViewData.swift
//  BookyBooky
//
//  Created by 김건우 on 7/6/23.
//

import SwiftUI

final class AddCompleteBookViewData: ObservableObject {
    @Published var selectedTargetDate = Date(timeIntervalSinceNow: 7 * 86_400)
}
