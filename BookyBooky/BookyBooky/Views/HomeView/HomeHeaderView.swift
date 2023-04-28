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
                        isPresentingSearchSheetView = true
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
                        isPresentingSettingsView = true
                    } label: {
                        settingImage
                    }
                    .opacity(scrollYOffset > 268 ? 0 : 1)
                    
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
            }
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
    var sortButtons: some View {
        ForEach(BookSort.allCases, id: \.self) { sort in
            Button {
                // 버튼을 클릭하면
                withAnimation(.spring()) {
                    // 곧바로 스크롤을 제일 위로 올리고
//                    scrollProxy.scrollTo("Scroll_To_Top", anchor: .top)
                    // 0.3초 대기 후, 정렬 애니메이션 수행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            selectedSort = sort
                        }
                        Haptics.shared.play(.rigid)
                    }
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
