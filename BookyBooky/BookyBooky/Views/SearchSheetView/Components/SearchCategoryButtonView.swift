//
//  CategoryButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct SearchCategoryButtonView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var selectedCategory: CategoryTypes
    let category: CategoryTypes
    @Binding var categoryAnimation: CategoryTypes
    let categoryNamespace: Namespace.ID
    let scrollProxy: ScrollViewProxy
    
    // MARK: - BODY
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                categoryAnimation = category
                scrollProxy.scrollTo(category.rawValue)
            }
            selectedCategory = category
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray.opacity(0.1))
                    .frame(height: 30)
                
                if categoryAnimation == category {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.black)
                        .frame(height: 30)
                        .matchedGeometryEffect(id: "roundedRectangle", in: categoryNamespace)
                }
                
                Text(category.rawValue)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(categoryAnimation == category ? .white : .black)
                    .padding(.horizontal, categoryAnimation == category ? 25 : 15)
            }
        }
        .padding(.horizontal, 15)
    }
}

// MARK: - PREVIEW

struct CategoryButtonView_Previews: PreviewProvider {
    @Namespace static var categoryNamespace: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { proxy in
            SearchCategoryButtonView(
                selectedCategory: .constant(.all),
                category: .all,
                categoryAnimation: .constant(.all),
                categoryNamespace: categoryNamespace,
                scrollProxy: proxy
            )
        }
    }
}
