//
//  HomeCategoryButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/26.
//

import SwiftUI

struct HomeCategoryButton: View {
    
    @EnvironmentObject var homeViewData: HomeViewData
    
    // MARK: - PROPERTIES
    
    let category: Category
    let scrollProxy: ScrollViewProxy
    let namespace: Namespace.ID
    
    // MARK: - INTIALIZER
    
    init(_ category: Category,
         scrollProxy: ScrollViewProxy,
         namespace: Namespace.ID) {
        self.category = category
        self.scrollProxy = scrollProxy
        self.namespace = namespace
    }
    
    
    // MARK: - BODY
    
    var body: some View {
        categoryButton
    }
    
    // MARK: - FUNCTIONS
    
    func selectCategory(_ type: Category) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            homeViewData.selectedCategoryFA = type
            scrollProxy.scrollTo("Scroll_To_Category", anchor: .top)
            scrollProxy.scrollTo("\(type.rawValue)")
        }
        homeViewData.selectedCategory = type
        print(homeViewData.selectedCategory)
    }
}

// MARK: - EXTENSIONS

extension HomeCategoryButton {
    var categoryButton: some View {
        Button {
            selectCategory(category)
        } label: {
            categoryLabel(category)
        }
    }
    
    func categoryLabel(_ type: Category) -> some View {
        Text(type.name)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(homeViewData.selectedCategoryFA == type ? .black : .gray)
            .overlay(alignment: .bottomLeading) {
                if homeViewData.selectedCategoryFA == type {
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

struct HomeCategoryButton_Preview: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            HomeCategoryButton(.all,
                               scrollProxy: scrollProxy,
                               namespace: namespace
            )
            .environmentObject(HomeViewData())
        }
    }
}
