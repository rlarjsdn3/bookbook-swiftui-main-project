//
//  TabShape.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct RoundedRectBLBR: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 25, height: 25)
        )
        
        return Path(path.cgPath)
    }
}

// MARK: - PREVIEW

struct TabShape_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectBLBR()
    }
}
