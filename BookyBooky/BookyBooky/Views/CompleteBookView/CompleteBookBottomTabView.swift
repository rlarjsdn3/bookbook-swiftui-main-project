//
//  ReadingBookTabSectionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct CompleteBookBottomTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var selectedTabType: CompleteBookTab = .overview
    @State private var selectedTabTypeForAnimation: CompleteBookTab = .overview
    
    @Namespace var namespace
    
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
        Section {
            bottomTabView(selectedTabType)
        } header: {
            tabButtonGroup
        }
    }
}

// MARK: - EXTENSIONS

extension CompleteBookBottomTabView {
    func bottomTabView(_ selected: CompleteBookTab) -> some View {
        Group {
            switch selected {
            case .overview:
                CompleteBookOutlineView(completeBook)
            case .analysis:
                CompleteBookAnalysisView(completeBook)
            case .collectSentences:
                CompleteBookSentenceView(completeBook)
            }
        }
    }
    
    var tabButtonGroup: some View {
        HStack {
            ForEach(CompleteBookTab.allCases, id: \.self) { type in
                Spacer()
                
                CompleteBookTabButton(
                    type,
                    selectedTab: $selectedTabType,
                    selectedTabFA: $selectedTabTypeForAnimation,
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
        CompleteBookBottomTabView(
            CompleteBook.preview,
            scrollYOffset: .constant(0.0)
        )
    }
}
