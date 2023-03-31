//
//  CategoryButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct CategoryButtonView: View {
    @Binding var selectedCategory: Category
    var category: Category
    @Binding var categoryAnimation: Category
    var categoryNamespace: Namespace.ID
    var scrollProxy: ScrollViewProxy
    
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
        .id(category.rawValue)
    }
}

struct CategoryButtonView_Previews: PreviewProvider {
    @Namespace static var categoryNamespace: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { proxy in
            CategoryButtonView(
                selectedCategory: .constant(.all),
                category: .all,
                categoryAnimation: .constant(.all),
                categoryNamespace: categoryNamespace,
                scrollProxy: proxy
            )
        }
    }
}
