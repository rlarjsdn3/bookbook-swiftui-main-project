//
//  ReadingBookTabSectionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct ReadingBookBottomTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var selectedTabType: ReadingBookTabType = .overview
    @State private var selectedTabTypeForAnimation: ReadingBookTabType = .overview
    
    @Namespace var namespace
    
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var readingBook: ReadingBook
    @Binding var scrollYOffset: CGFloat
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook, scrollYOffset: Binding<CGFloat>) {
        self.readingBook = readingBook
        self._scrollYOffset = scrollYOffset
    }
    
    // MARK: - BODY
    
    var body: some View {
        Section {
            tabView(selectedTabType)
        } header: {
            tabButtonGroup
        }
    }
}

// MARK: - EXTENSIONS

extension ReadingBookBottomTabView {
    func tabView(_ selectedTabType: ReadingBookTabType) -> some View {
        Group {
            switch selectedTabType {
            case .overview:
                ReadingBookOutlineView(readingBook: readingBook)
            case .analysis:
                ReadingBookAnalysisView(readingBook: readingBook)
            case .collectSentences:
                ReadingBookCollectSentencesView(readingBook: readingBook)
            }
        }
    }
    
    var tabButtonGroup: some View {
        HStack {
            ForEach(ReadingBookTabType.allCases, id: \.self) { type in
                Spacer()
                
                ReadingBookTabButton(
                    type,
                    selectedTabType: $selectedTabType,
                    selectedTabTypeForAnimation: $selectedTabTypeForAnimation,
                    namespace: namespace
                )
                
                Spacer()
            }
            .id("Scroll_To_Category")
        }
        .background(.white)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottom) {
            Divider()
        }
        .padding(.bottom, 10)
    }
}

// MARK: - PREVIEW

struct ReadingBookTabSectionView_Previews: PreviewProvider {    
    static var previews: some View {
        ReadingBookBottomTabView(
            ReadingBook.preview,
            scrollYOffset: .constant(0.0)
        )
    }
}
