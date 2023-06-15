//
//  CategoryButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct SearchCategoryButton: View {
    
    // MARK: - PROPERTIES
    
    let type: CategoryType
    @Binding var selectedCategory: CategoryType
    @Binding var selectedCategoryForAnimation: CategoryType
    let namespace: Namespace.ID
    let scrollProxy: ScrollViewProxy
    
    // MARK: - INTIALIZER
    
    init(_ type: CategoryType,
         selectedCategory: Binding<CategoryType>, selectedCategoryForAnimation: Binding<CategoryType>,
         namespace: Namespace.ID, scrollProxy: ScrollViewProxy) {
        self.type = type
        self._selectedCategory = selectedCategory
        self._selectedCategoryForAnimation = selectedCategoryForAnimation
        self.namespace = namespace
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedCategoryForAnimation = type
                scrollProxy.scrollTo(type.rawValue)
            }
            selectedCategory = type
            HapticManager.shared.impact(.light)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray.opacity(0.1))
                    .frame(height: 30)
                
                if selectedCategoryForAnimation == type {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.black)
                        .frame(height: 30)
                        .matchedGeometryEffect(id: "roundedRectangle", in: namespace)
                }
                
                Text(type.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(selectedCategoryForAnimation == type ? .white : .black)
                    .padding(.horizontal, selectedCategoryForAnimation == type ? 15 : 15)
            }
        }
        .padding(.horizontal, 15)
    }
}

// MARK: - PREVIEW

struct CategoryButtonView_Previews: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { proxy in
            SearchCategoryButton(
                .all,
                selectedCategory: .constant(.all),
                selectedCategoryForAnimation: .constant(.all),
                namespace: namespace,
                scrollProxy: proxy
            )
        }
    }
}
