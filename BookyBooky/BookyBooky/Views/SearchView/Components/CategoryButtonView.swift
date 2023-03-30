//
//  CategoryButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct CategoryButtonView: View {
    @Binding var categorySelected: Category
    var category: Category
    @Binding var selectedAnimation: Category
    var selectedNamespace: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedAnimation = category
            }
            categorySelected = category
        } label: {
            ZStack {
                if selectedAnimation == category {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.black)
                        .frame(height: 30)
                        .matchedGeometryEffect(id: "roundedRectangle", in: selectedNamespace)
                }
                
                Text(category.rawValue)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(selectedAnimation == category ? .white : .black)
                    .padding(.horizontal, selectedAnimation == category ? 20 : 0)
            }
        }
    }
}

struct CategoryButtonView_Previews: PreviewProvider {
    @Namespace static var selectedNamespace: Namespace.ID
    
    static var previews: some View {
        CategoryButtonView(
            categorySelected: .constant(.all),
            category: .all,
            selectedAnimation: .constant(.all),
            selectedNamespace: selectedNamespace
        )
    }
}
