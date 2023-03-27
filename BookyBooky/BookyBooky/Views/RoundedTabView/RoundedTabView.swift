//
//  RoundedTabView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct RoundedTabView: View {
    @Binding var selected: TabItem
    @Namespace var namespace: Namespace.ID
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { item in
                TabButtonView(selected: $selected, item: item, namespace: namespace)
            }
        }
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .frame(height: 100)
            }
            .offset(y: 18)
        }
    }
}

struct RoundedTabView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedTabView(selected: .constant(.home))
    }
}
