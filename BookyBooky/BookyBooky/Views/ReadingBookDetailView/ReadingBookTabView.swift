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
    
    @State private var selectedTabType: ReadingBookTabTypes = .overview
    @State private var selectedTabTypeForAnimation: ReadingBookTabTypes = .overview
    
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
    func viewThatChangesAccordingToTab(_ selectedTabType: ReadingBookTabTypes) -> some View {
        Group {
            switch selectedTabType {
            case .overview:
                ReadingBookOutlineView(readingBook: readingBook)
            case .analysis:
                ReadingBookAnalysisView(readingBook: readingBook)
            case .collectSentences:
                ReadingBookCollectSentencesView()
            }
        }
    }
    
    var readingBooktTabButtons: some View {
        HStack {
            ForEach(ReadingBookTabTypes.allCases, id: \.self) { item in
                Spacer()
                
                // ReadingBookTabButton 파일로 Extract하기
                
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        selectedTabTypeForAnimation = item
                    }
                    selectedTabType = item
                } label: {
                    Text(item.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(selectedTabTypeForAnimation == item ? .black : .gray)
                        .overlay(alignment: .bottomLeading) {
                            if selectedTabTypeForAnimation == item {
                                Rectangle()
                                    .offset(y: 15)
                                    .fill(.black)
                                    .frame(width: 40, height: 1)
                                    .matchedGeometryEffect(id: "underline", in: namespace)
                            }
                        }
                        .padding(.horizontal, 10)
                }
                .padding(.vertical, 10)
                .padding([.horizontal, .bottom], 5)
                .id("\(item.name)")
                
                Spacer()
            }
            .id("Scroll_To_Category")
        }
        .background(.white)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottom) {
            Divider()
        }
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
