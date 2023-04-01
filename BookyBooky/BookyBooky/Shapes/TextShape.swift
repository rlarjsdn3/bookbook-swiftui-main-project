//
//  TextShape.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/01.
//

import SwiftUI

struct TextShape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: 30, height: 30)
        )
        
        return Path(path.cgPath)
    }
}

struct TextShape_Previews: PreviewProvider {
    static var previews: some View {
        TextShape()
    }
}
