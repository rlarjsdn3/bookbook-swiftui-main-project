//
//  ReadingBookTabButton.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/19.
//

import SwiftUI

struct CompleteBookTabButton: View {
    
    // MARK: - PROPERTIES
    
    let type: CompleteBookTab
    @Binding var selectedTab: CompleteBookTab
    @Binding var selectedTabFA: CompleteBookTab
    let namespace: Namespace.ID
    
    // MARK: - INTIALIZER
    
    init(_ type: CompleteBookTab,
         selectedTab: Binding<CompleteBookTab>,
         selectedTabFA: Binding<CompleteBookTab>,
         namespace: Namespace.ID) {
        self.type = type
        self._selectedTab = selectedTab
        self._selectedTabFA = selectedTabFA
        self.namespace = namespace
    }
    
    // MARK: - BODY
    
    var body: some View {
        tabButton
    }
}

extension CompleteBookTabButton {
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
    
    func selectType(_ type: CompleteBookTab) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            selectedTabFA = type
        }
        selectedTab = type
    }
    
    func tabLabel(_ type: CompleteBookTab) -> some View {
        Text(type.name)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(selectedTabFA == type ? .black : .gray)
            .overlay(alignment: .bottomLeading) {
                if selectedTabFA == type {
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
        CompleteBookTabButton(
            .overview,
            selectedTab: .constant(.overview),
            selectedTabFA: .constant(.overview),
            namespace: namespace
        )
    }
}
