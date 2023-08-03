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
    
    let type: Category
    let namespace: Namespace.ID
    let scrollProxy: ScrollViewProxy
    
    let haptic = HapticManager()
    
    // MARK: - INTIALIZER
    
    init(_ type: Category,
         namespace: Namespace.ID, scrollProxy: ScrollViewProxy) {
        self.type = type
        self.namespace = namespace
        self.scrollProxy = scrollProxy
    }
    
    // MARK: - BODY
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                searchSheetViewData.selectedCategoryFA = type
                scrollProxy.scrollTo(type.rawValue)
            }
            searchSheetViewData.selectedCategory = type
            haptic.impact(.light)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray.opacity(0.1))
                    .frame(height: 30)
                
                if searchSheetViewData.selectedCategoryFA == type {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.black)
                        .frame(height: 30)
                        .matchedGeometryEffect(id: "roundedRectangle", in: namespace)
                }
                
                Text(type.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(searchSheetViewData.selectedCategoryFA == type ? .white : .black)
                    .padding(.horizontal, 15)
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
                namespace: namespace,
                scrollProxy: proxy
            )
            .environmentObject(SearchSheetViewData())
        }
    }
}
