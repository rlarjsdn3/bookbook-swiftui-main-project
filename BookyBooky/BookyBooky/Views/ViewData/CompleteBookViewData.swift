//
//  CompleteBookViewData.swift
//  BookyBooky
//
//  Created by 김건우 on 7/4/23.
//

import SwiftUI

final class CompleteBookViewData: ObservableObject {
    @Published var pageRead = 999.0
    
    @Published var scrollYOffset: CGFloat = 0.0
    @Published var selectedTab: CompleteBookTab = .overview
    @Published var selectedTabFA: CompleteBookTab = .overview
    
    @Published var isPresentingConfettiView = false
}
