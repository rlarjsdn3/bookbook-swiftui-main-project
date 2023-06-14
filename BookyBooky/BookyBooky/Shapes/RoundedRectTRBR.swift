//
//  CoverShape.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/01.
//

import SwiftUI

struct RoundedRectTRBR: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: 25, height: 25)
        )
        return Path(path.cgPath)
    }
}

// MARK: - PREVIEW

struct CoverShape_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectTRBR()
    }
}
