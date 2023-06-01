//
//  ReadingBookTabSectionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct ReadingBookTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var selectedTabType: ReadingBookTabType = .overview
    @State private var selectedTabTypeForAnimation: ReadingBookTabType = .overview
    
    // MARK: - PROPERTIES
    
    let readingBook: ReadingBook
    @Binding var scrollYOffset: Double
    let namespace: Namespace.ID
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook, scrollYOffset: Binding<Double>, namespace: Namespace.ID) {
        self.readingBook = readingBook
        self._scrollYOffset = scrollYOffset
        self.namespace = namespace
    }
    
    // MARK: - BODY
    
    var body: some View {
        Section {
            viewThatChangesAccordingToTab(selectedTabType)
        } header: {
            readingBooktTabButtons
        }
    }
}

// MARK: - EXTENSIONS

extension ReadingBookTabView {
    func viewThatChangesAccordingToTab(_ selectedTabType: ReadingBookTabType) -> some View {
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
    
    var readingBooktTabButtons: some View {
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
    @Namespace static var namespace
    
    static var previews: some View {
        ReadingBookTabView(
            ReadingBook.preview,
            scrollYOffset: .constant(0.0),
            namespace: namespace
        )
    }
}
