//
//  RoundedTabView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct CustomTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Namespace var namespace
    
    // MARK: - PROPERTIES
    
    @Binding var selectedTab: CustomMainTab
    
    // MARK: - INTIALIZER
    
    init(selection selectedTab: Binding<CustomMainTab>) {
        self._selectedTab = selectedTab
    }
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            // for iOS 17.0
            #if false
            ForEach(CustomMainTab.allCases, id: \.self) { category in
                Spacer()
                TabButton(
                    category,
                    selectedTab: $selectedTab,
                    namespace: namespace
                )
                Spacer()
            }
            #endif
            ForEach(CustomMainTab.allCases, id: \.self) { type in
                if type != .analysis {
                    Spacer()
                    TabButton(
                        type,
                        selectedTab: $selectedTab,
                        namespace: namespace
                    )
                    Spacer()
                }
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

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(selection: .constant(.home))
    }
}
