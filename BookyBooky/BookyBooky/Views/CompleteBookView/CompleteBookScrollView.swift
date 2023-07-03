//
//  ReadingBookDetailScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct CompleteBookScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var startOffset: CGFloat = 0.0
    
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var completeBook: CompleteBook
    @Binding var scrollYOffset: CGFloat
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook, scrollYOffset: Binding<CGFloat>) {
        self.completeBook = completeBook
        self._scrollYOffset = scrollYOffset
    }
    
    // MARK: - BODY
    
    var body: some View {
        compBookScrollContent
    }
}

// MARK: - EXTENSIONS

extension CompleteBookScrollView {
    var compBookScrollContent: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                CompleteBookTopInfoView(completeBook)
                
                CompleteBookBottomTabView(
                    completeBook,
                    scrollYOffset: $scrollYOffset
                )
            }
            .trackScrollYOffet($startOffset, yOffset: $scrollYOffset)
        }
    }
}

// MARK: - PREVIEW

struct ReadingBookDetailScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteBookScrollView(CompleteBook.preview, scrollYOffset: .constant(0.0))
    }
}
