//
//  HomeCategoryButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/26.
//

import SwiftUI

struct HomeCategoryButtonsView: View {
    let category: Category
    @Binding var selectedCategory: Category
    let scrollProxy: ScrollViewProxy
    let underlineAnimation: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedCategory = category
                scrollProxy.scrollTo("\(category.rawValue)")
            }
        } label: {
            Text(category.rawValue)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(selectedCategory == category ? .black : .gray)
                .overlay(alignment: .bottomLeading) {
                    if selectedCategory == category {
                        Rectangle()
                            .offset(y: 9)
                            .fill(.black)
                            .frame(width: 40, height: 1)
                            .matchedGeometryEffect(id: "underline", in: underlineAnimation)
                    }
                }
                .padding(.horizontal)
        }
        .id("\(category.rawValue)")
    }
}

struct HomeCategoryButtonsView_Previews: PreviewProvider {
    @Namespace static var underlineAnimation: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            HomeCategoryButtonsView(category: .all, selectedCategory: .constant(.all), scrollProxy: scrollProxy, underlineAnimation: underlineAnimation)
        }
    }
}
