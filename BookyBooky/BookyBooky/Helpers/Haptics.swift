//
//  Haptics.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//


import UIKit

class Haptics {
    static let shared = Haptics()
    
    private init() { }
    
    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(type)
        }
}
