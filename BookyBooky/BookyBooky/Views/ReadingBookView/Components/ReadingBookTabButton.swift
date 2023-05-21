//
//  ReadingBookTabButton.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/19.
//

import SwiftUI

struct ReadingBookTabButton: View {
    
    // MARK: - PROPERTIES
    
    let type: ReadingBookTabTypes
    @Binding var selectedTabType: ReadingBookTabTypes
    @Binding var selectedTabTypeForAnimation: ReadingBookTabTypes
    let namespace: Namespace.ID
    
    // MARK: - INTIALIZER
    
    init(_ type: ReadingBookTabTypes,
         selectedTabType: Binding<ReadingBookTabTypes>,
         selectedTabTypeForAnimation: Binding<ReadingBookTabTypes>,
         namespace: Namespace.ID) {
        self.type = type
        self._selectedTabType = selectedTabType
        self._selectedTabTypeForAnimation = selectedTabTypeForAnimation
        self.namespace = namespace
    }
    
    // MARK: - BODY
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedTabTypeForAnimation = type
            }
            selectedTabType = type
        } label: {
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
        .padding(.vertical, 10)
        .padding([.horizontal, .bottom], 5)
        .id("\(type.name)")
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
