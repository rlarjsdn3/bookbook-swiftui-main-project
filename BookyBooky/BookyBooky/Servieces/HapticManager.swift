//
//  Haptics.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//


import UIKit

class HapticManager {
    
    init() { }
    
    func impact(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
