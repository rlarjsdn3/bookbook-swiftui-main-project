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
    @Binding var selectedAnimation: Category
    let scrollProxy: ScrollViewProxy
    let underlineAnimation: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedAnimation = category
                scrollProxy.scrollTo("Scroll_To_Category", anchor: .top)
                scrollProxy.scrollTo("\(category.rawValue)")
//                scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
            }
            selectedCategory = category
        } label: {
            Text(category.rawValue)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(selectedAnimation == category ? .black : .gray)
                .overlay(alignment: .bottomLeading) {
                    if selectedAnimation == category {
                        Rectangle()
                            .offset(y: 15)
                            .fill(.black)
                            .frame(width: 40, height: 1)
                            .matchedGeometryEffect(id: "underline", in: underlineAnimation)
                    }
                }
                .padding(.horizontal, 10)
        }
    }
}

struct HomeCategoryButtonsView_Previews: PreviewProvider {
    @Namespace static var underlineAnimation: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            HomeCategoryButtonsView(category: .all, selectedCategory: .constant(.all), selectedAnimation: .constant(.all), scrollProxy: scrollProxy, underlineAnimation: underlineAnimation)
        }
    }
}
