//
//  SearchSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI

struct SearchSheetView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var query = ""
    
    var body: some View {
        VStack {
            SearchSheetTextFieldView(query: $query)
            
            ScrollView {
                VStack {
                    if let bookSearchList = viewModel.bookSearchList {
                        ForEach(bookSearchList.item, id: \.self) { item in
                            Text("\(item.title)")
                        }
                    } else {
                        Text("오류")
                    }
                }
            }
            
            
        }
    }
}

struct SearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSheetView()
            .environmentObject(ViewModel())
    }
}
