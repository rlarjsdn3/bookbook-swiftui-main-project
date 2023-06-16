//
//  ReadingBookTabButton.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/19.
//

import SwiftUI

struct ReadingBookTabButton: View {
    
    // MARK: - PROPERTIES
    
    let type: ReadingBookTab
    @Binding var selectedTabType: ReadingBookTab
    @Binding var selectedTabTypeForAnimation: ReadingBookTab
    let namespace: Namespace.ID
    
    // MARK: - INTIALIZER
    
    init(_ type: ReadingBookTab,
         selectedTabType: Binding<ReadingBookTab>,
         selectedTabTypeForAnimation: Binding<ReadingBookTab>,
         namespace: Namespace.ID) {
        self.type = type
        self._selectedTabType = selectedTabType
        self._selectedTabTypeForAnimation = selectedTabTypeForAnimation
        self.namespace = namespace
    }
    
    // MARK: - BODY
    
    var body: some View {
        tabButton
    }
}

extension ReadingBookTabButton {
    var tabButton: some View {
        Button {
            selectType(type)
        } label: {
            tabLabel(type)
        }
        .padding(.vertical, 10)
        .padding([.horizontal, .bottom], 5)
        .id("\(type.name)")
    }
    
    func selectType(_ type: ReadingBookTab) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            selectedTabTypeForAnimation = type
        }
        selectedTabType = type
    }
    
    func tabLabel(_ type: ReadingBookTab) -> some View {
        Text(type.name)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(selectedTabTypeForAnimation == type ? .black : .gray)
            .overlay(alignment: .bottomLeading) {
                if selectedTabTypeForAnimation == type {
                    Rectangle()
                        .offset(y: 15)
                        .fill(.black)
                        .frame(width: 40, height: 1)
                        .matchedGeometryEffect(id: "underline", in: namespace)
                }
            }
            .padding(.horizontal, 10)
    }
}

// MARK: - PREVIEW

struct ReadingBookTabButton_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        ReadingBookTabButton(
            .overview,
            selectedTabType: .constant(.overview),
            selectedTabTypeForAnimation: .constant(.overview),
            namespace: namespace
        )
    }
}
