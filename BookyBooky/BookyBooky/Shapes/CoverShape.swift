//
//  CoverShape.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/01.
//

import SwiftUI

struct CoverShape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: 30, height: 30)
        )
        
        return Path(path.cgPath)
    }
}

struct CoverShape_Previews: PreviewProvider {
    static var previews: some View {
        CoverShape()
    }
}
