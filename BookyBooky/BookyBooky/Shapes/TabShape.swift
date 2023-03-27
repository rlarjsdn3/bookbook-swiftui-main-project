//
//  TabShape.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct TabShape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 30, height: 30)
        )
        
        return Path(path.cgPath)
    }
}

struct TabShape_Previews: PreviewProvider {
    static var previews: some View {
        TabShape()
    }
}
