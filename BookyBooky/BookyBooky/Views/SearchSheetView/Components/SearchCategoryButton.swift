//
//  CategoryButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/31.
//

import SwiftUI

struct SearchCategoryButton: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var searchSheetViewData: SearchSheetViewData
    
    // MARK: - PROPERTIES
    
    let category: Category
    let namespace: Namespace.ID
    let scrollProxy: ScrollViewProxy
    
    let haptic = HapticManager()
    
    // MARK: - INTIALIZER
    
    init(_ category: Category,
         namespace: Namespace.ID, scrollProxy: ScrollViewProxy) {
        self.category = category
        self.namespace = namespace
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        Button {
            selectCategory(category)
        } label: {
            categoryLabel
        }
        .padding(.horizontal, 15)
    }
    
    func selectCategory(_ category: Category) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            searchSheetViewData.selectedCategoryFA = category
            scrollProxy.scrollTo(category.rawValue)
        }
        searchSheetViewData.selectedCategory = category
        haptic.impact(.light)
    }
}

extension SearchCategoryButton {
    var categoryLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.gray.opacity(0.1))
                .frame(height: 30)
            
            if searchSheetViewData.selectedCategoryFA == category {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.black)
                    .frame(height: 30)
                    .matchedGeometryEffect(id: "roundedRectangle", in: namespace)
            }
            
            Text(category.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(searchSheetViewData.selectedCategoryFA == category ? .white : .black)
                .padding(.horizontal, 15)
        }
    }
}

// MARK: - PREVIEW

struct CategoryButtonView_Previews: PreviewProvider {
    @Namespace static var namespace: Namespace.ID
    
    static var previews: some View {
        ScrollViewReader { proxy in
            SearchCategoryButton(
                .all,
                namespace: namespace,
                scrollProxy: proxy
            )
            .environmentObject(SearchSheetViewData())
        }
    }
}
