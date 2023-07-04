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
    
    let type: Category
    let scrollProxy: ScrollViewProxy
    let namespace: Namespace.ID
    
    // MARK: - INTIALIZER
    
    init(_ type: Category,
         scrollProxy: ScrollViewProxy,
         namespace: Namespace.ID) {
        self.type = type
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
    }
}

// MARK: - EXTENSIONS

extension HomeCategoryButton {
    var categoryButton: some View {
        Button {
            selectCategory(type)
        } label: {
            categoryLabel(type)
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

struct HomeCategoryButton_Previews: PreviewProvider {
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
