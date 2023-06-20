//
//  TabButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct TabButton: View {
    
    // MARK: - PROPERTIES
    
    var type: CustomMainTab
    @Binding var selectedTab: CustomMainTab
    var namespace: Namespace.ID
    
    // MARK: - INTIALIZER
    
    init(
        _ type: CustomMainTab,
        selectedTab: Binding<CustomMainTab>,
        namespace: Namespace.ID) {
        self.type = type
        self._selectedTab = selectedTab
        self.namespace = namespace
    }
    
    // MARK: - BODY
    
    var body: some View {
        Spacer()
        
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedTab = type
            }
            HapticManager.shared.impact(.light)
        } label: {
            VStack(spacing: -5) {
                Image(systemName: type.icon)
                    .font(.title3)
                    .offset(y: selectedTab == type ? -8 : 0)
                    .foregroundColor(selectedTab == type ? type.colorPressed : type.color)
                    .scaleEffect(selectedTab == type ? 1.0 : 0.9)
                
                if selectedTab == type {
                    Text(type.name)
                        .font(.caption2)
                        .foregroundColor(.black)
                }
            }
            .frame(height: 20)
            .padding(.bottom, 5)
            .overlay {
                if selectedTab == type {
                    RoundedRectBLBR()
                        .foregroundColor(.black)
                        .frame(width: 40, height: 5)
                        .offset(y: -32)
                        .matchedGeometryEffect(id: "tabShape", in: namespace)
                }
            }
        }
        
        Spacer()
    }
}

// MARK: - PREVIEW

struct TabButtonView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        TabButton(
            .home,
            selectedTab: .constant(.home),
            namespace: namespace
        )
    }
}
