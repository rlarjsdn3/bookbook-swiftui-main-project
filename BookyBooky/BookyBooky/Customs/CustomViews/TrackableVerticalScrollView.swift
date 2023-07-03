//
//  TrackableVerticalScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 7/3/23.
//

import SwiftUI

struct TrackableVerticalScrollView<Content>: View where Content: View {
    
    @State private var startOffset: CGFloat = 0.0
    
    @Binding var yOffset: CGFloat
    let content: () -> Content
    
    var body: some View {
        ScrollView {
            content()
                .trackScrollYOffet($startOffset, yOffset: $yOffset)
        }
    }
}
