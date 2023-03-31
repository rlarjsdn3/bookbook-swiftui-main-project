//
//  SearchSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchSheetView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var query = ""
    @State private var categorySelected: Category = .all
    @State private var selectedAnimation: Category = .all
    
    var body: some View {
        VStack {
            SearchSheetTextFieldView(
                query: $query,
                categorySelected: $categorySelected,
                animationSelected: $selectedAnimation
            )
            
            SearchSheetCategoryView(
                categorySelected: $categorySelected,
                selectedAnimation: $selectedAnimation
            )
            
            ZStack {
                SearchSheetScrollView(categorySelected: $categorySelected)
            }
            
            Spacer()
        }
    }
}

struct SearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetView()
            .environmentObject(BookViewModel())
    }
}
