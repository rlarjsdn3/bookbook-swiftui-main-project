//
//  RoundedCoverShape.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/19.
//

import SwiftUI

struct RoundedRect: Shape {
    
    let cornerRadii: CGSize
    let roundingCorners: UIRectCorner
    
    init(cornerRadii: CGSize = CGSize(width: 25, height: 25), byRoundingCorners roundingCorners: UIRectCorner) {
        self.cornerRadii = cornerRadii
        self.roundingCorners = roundingCorners
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: roundingCorners,
            cornerRadii: cornerRadii
        )
        
        return Path(path.cgPath)
    }
}

// MARK: - PREVIEW

struct RoundedCoverShape_Preview: PreviewProvider {
    static var previews: some View {
        RoundedRect(byRoundingCorners: [])
    }
}
