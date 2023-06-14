//
//  RoundedCoverShape.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/19.
//

import SwiftUI

struct RoundedRect: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.allCorners],
            cornerRadii: CGSize(width: 25, height: 25)
        )
        
        return Path(path.cgPath)
    }
}

// MARK: - PREVIEW

struct RoundedCoverShape_Preview: PreviewProvider {
    static var previews: some View {
        RoundedRect()
    }
}
