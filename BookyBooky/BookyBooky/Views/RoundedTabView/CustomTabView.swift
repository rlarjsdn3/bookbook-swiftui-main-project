//
//  RoundedTabView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct CustomTabView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var selectedTabViewType: TabViewType
    
    // MARK: - WRAPPER PROPERTIES
    
    @Namespace var namespace
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            ForEach(TabViewType.allCases, id: \.self) { type in
                TabButton(
                    type,
                    selectedTabViewType: $selectedTabViewType,
                    namespace: namespace
                )
            }
        }
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 0.2)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(height: 100)
            }
            .offset(y: 15.5)
        }
        // 베젤이 없는 아이폰(iPhone 14 등)은 하단 간격 0으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 하단 간격 20으로 설정
        .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
    }
}

// MARK: - PREVIEW

struct RoundedTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(selectedTabViewType: .constant(.home))
    }
}
