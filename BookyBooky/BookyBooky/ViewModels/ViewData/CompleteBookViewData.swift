//
//  CompleteBookViewData.swift
//  BookyBooky
//
//  Created by 김건우 on 7/4/23.
//

import SwiftUI

final class CompleteBookViewData: ObservableObject {
    @Published var scrollYOffset: CGFloat = 0.0
    
    @Published var selectedTab: CompleteBookTab = .overview
    @Published var selectedTabFA: CompleteBookTab = .overview
    
    @Published var pageProgress = 999.0
    @Published var isPresentingConfettiView = false
}
