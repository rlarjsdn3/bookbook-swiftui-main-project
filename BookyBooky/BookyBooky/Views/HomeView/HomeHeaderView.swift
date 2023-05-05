//
//  HomeHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct HomeHeaderView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Binding var selectedSort: BookSort
    @Binding var scrollYOffset: Double
    
    @State private var isPresentingSettingsView = false
    @State private var isPresentingSearchSheetView = false
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Spacer()
            
            navigationTitle
            
            Spacer()
        }
        .overlay {
            navigationBarButtons
        }
        .sheet(isPresented: $isPresentingSettingsView) {
            SettingsView()
        }
        .sheet(isPresented: $isPresentingSearchSheetView) {
            SearchSheetView()
        }
        .padding(.vertical)
    }
}

// MARK: - EXTENSIONS

extension HomeHeaderView {
    var navigationTitle: some View {
        Text("홈")
            .navigationTitleStyle()
            .opacity(scrollYOffset > 10 ? 1 : 0)
    }
    
    var navigationBarButtons: some View {
        HStack {
            addTargetBookMenu

            Spacer()
            
            // 추후 프로필 이미지 기능 구현 시 코드 수정 예정
            ZStack {
                settingsButton
                
                bookSortMenu
            }
        }
    }
    
    var addTargetBookMenu: some View {
        Menu {
            Section {
                Button {
                    // do somethings...
                } label: {
                    Label("직접 추가", systemImage: "pencil.line")
                }
                
                Button {
                    isPresentingSearchSheetView = true
                } label: {
                    Label("검색 추가", systemImage: "magnifyingglass")
                }
            } header: {
                Text("도서 추가")
            }
        } label: {
            searchImage
        } primaryAction: {
            isPresentingSearchSheetView = true
        }
    }
    
    var settingsButton: some View {
        Button {
            isPresentingSettingsView = true
        } label: {
            settingImage
        }
        .opacity(scrollYOffset > 268 ? 0 : 1)
    }
    
    var bookSortMenu: some View {
        Menu {
            Section {
                sortButtons
            } header: {
                Text("도서 정렬")
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
    
    var sortButtons: some View {
        ForEach(BookSort.allCases, id: \.self) { sort in
            Button {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                        selectedSort = sort
                    }
                    HapticManager.shared.impact(.rigid)
                }
            } label: {
                HStack {
                    Text(sort.rawValue)
                    
                    // 현재 선택한 정렬 타입에 체크마크 표시
                    if selectedSort == sort {
                        checkmark
                    }
                }
            }
        }
    }
    
    var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.title3)
    }
    
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
        HomeHeaderView(selectedSort: .constant(.latestOrder), scrollYOffset: .constant(0.0))
    }
}
