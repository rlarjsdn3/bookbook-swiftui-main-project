//
//  HomeHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct HomeHeaderView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Binding var scrollYOffset: Double
    
    @State private var showSearchSheetView = false
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("홈")
                .navigationTitleStyle()
                .opacity(scrollYOffset > 10 ? 1 : 0)
            
            Spacer()
        }
        .overlay {
            HStack {
                Menu {
                    Button {
                        // do somethings...
                    } label: {
                        Label("직접 추가", systemImage: "pencil.line")
                    }
                    
                    Button {
                        showSearchSheetView = true
                    } label: {
                        Label("검색 추가", systemImage: "magnifyingglass")
                    }
                } label: {
                    searchImage
                }
                
                Spacer()
                
                // 추후 프로필 이미지 기능 구현 시 코드 수정 예정
                ZStack {
                    Button {
                        
                    } label: {
                        settingImage
                    }
                    .opacity(scrollYOffset > 268 ? 0 : 1)
                    
                    Menu {
                        Button("최근 읽은 순") {
                            
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .offset(y: scrollYOffset > 270 ? 0 : 5)
                    .opacity(scrollYOffset > 270 ? 1 : 0)
                    .navigationBarItemStyle()
                }
            }
        }
        .sheet(isPresented: $showSearchSheetView) {
            SearchSheetView()
        }
        .padding(.vertical)
    }
}

// MARK: - EXTENSIONS

extension HomeHeaderView {
    var searchImage: some View {
        Image(systemName: "plus")
            .navigationBarItemStyle()
    }
    
    var settingImage: some View {
        Image(systemName: "gearshape.fill")
            .navigationBarItemStyle()
    }
}

// MARK: - PREVIEW

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView(scrollYOffset: .constant(0.0))
    }
}
