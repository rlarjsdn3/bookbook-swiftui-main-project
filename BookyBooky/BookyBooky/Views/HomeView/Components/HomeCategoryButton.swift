//
//  HomeCategoryButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/26.
//

import SwiftUI

struct HomeCategoryButton: View {
    
    // MARK: - PROPERTIES
    
    let type: CategoryType
    @Binding var selectedCategoryType: CategoryType
    @Binding var selectedCategoryTypeForAnimation: CategoryType
    let scrollProxy: ScrollViewProxy
    let namespace: Namespace.ID
    
    // MARK: - INTIALIZER
    
    init(_ type: CategoryType,
         selectedCategoryType: Binding<CategoryType>, selectedCategoryTypeForAnimation: Binding<CategoryType>,
         scrollProxy: ScrollViewProxy, namespace: Namespace.ID) {
        self.type = type
        self._selectedCategoryType = selectedCategoryType
        self._selectedCategoryTypeForAnimation = selectedCategoryTypeForAnimation
        self.scrollProxy = scrollProxy
        self.namespace = namespace
    }
    
    
    // MARK: - BODY
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedCategoryTypeForAnimation = type
                scrollProxy.scrollTo("Scroll_To_Category", anchor: .top)
                scrollProxy.scrollTo("\(type.rawValue)")
            }
            selectedCategoryType = type
        } label: {
            Text(type.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(selectedCategoryTypeForAnimation == type ? .black : .gray)
                .overlay(alignment: .bottomLeading) {
                    if selectedCategoryTypeForAnimation == type {
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
}

struct HomeCategoryButton_Previews: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            HomeCategoryButton(.all,
                               selectedCategoryType: .constant(.all),
                               selectedCategoryTypeForAnimation: .constant(.all),
                               scrollProxy: scrollProxy,
                               namespace: namespace
            )
        }
    }
}
