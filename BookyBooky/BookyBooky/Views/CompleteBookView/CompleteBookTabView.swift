//
//  ReadingBookTabSectionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct CompleteBookTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var completeBookViewData: CompleteBookViewData
    
    @Namespace var namespace
    
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var completeBook: CompleteBook
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook) {
        self.completeBook = completeBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        Section {
            bottomTabView(completeBookViewData.selectedTab)
        } header: {
            tabButtonGroup
        }
    }
}

// MARK: - EXTENSIONS

extension CompleteBookTabView {
    func bottomTabView(_ selected: CompleteBookTab) -> some View {
        Group {
            switch selected {
            case .overview:
                CompleteBookOutlineView(completeBook)
            case .analysis:
                CompleteBookAnalysisView(completeBook)
            case .sentences:
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

struct CompleteBookTabView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteBookTabView(CompleteBook.preview)
            .environmentObject(CompleteBookViewData())
    }
}
