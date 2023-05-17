//
//  HomeHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct HomeHeaderView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isPresentingSettingsView = false
    @State private var isPresentingSearchSheetView = false
    
    // MARK: - PROPERTIES
    
    @Binding var scrollYOffset: Double
    @Binding var selectedBookSortType: BookSortCriteriaType
    
    // MARK: - INITALIZER
    
    init(_ scrollYOffset: Binding<Double>, selectedBookSortType: Binding<BookSortCriteriaType>) {
        self._scrollYOffset = scrollYOffset
        self._selectedBookSortType = selectedBookSortType
    }
    
    // MARK: - BODY
    
    var body: some View {
        navigationBar
    }
}

// MARK: - EXTENSIONS

extension HomeHeaderView {
    var navigationBar: some View {
        HStack {
            Spacer()
            
            navigationBarTitle
            
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
    
    var navigationBarTitle: some View {
        Text("홈")
            .navigationTitleStyle()
            .opacity(scrollYOffset > 10 ? 1 : 0)
    }
    
    var navigationBarButtons: some View {
        HStack {
            addReadingBookMenu

            Spacer()
            
            // 추후 프로필 이미지 기능 구현 시 코드 수정 예정
            ZStack {
                settingsButton
                
                bookSortCriteriaMenu
            }
        }
    }
    
    var addReadingBookMenu: some View {
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
            plusSFSymbolImage
        } primaryAction: {
            isPresentingSearchSheetView = true
        }
    }
    
    var plusSFSymbolImage: some View {
        Image(systemName: "plus")
            .navigationBarItemStyle()
    }
    
    var settingsButton: some View {
        Button {
            isPresentingSettingsView = true
        } label: {
            gearShapeSFSymbolImage
        }
        .opacity(scrollYOffset > 268 ? 0 : 1)
    }
    
    var gearShapeSFSymbolImage: some View {
        Image(systemName: "gearshape.fill")
            .navigationBarItemStyle()
    }
    
    var bookSortCriteriaMenu: some View {
        Menu {
            Section {
                bookSortMenuButtons
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
    
    var bookSortMenuButtons: some View {
        ForEach(BookSortCriteriaType.allCases, id: \.self) { type in
            Button {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                        selectedBookSortType = type
                    }
                    HapticManager.shared.impact(.rigid)
                }
            } label: {
                HStack {
                    Text(type.rawValue)
                    
                    // 현재 선택한 정렬 타입에 체크마크 표시
                    if selectedBookSortType == type {
                        checkMarkSFSymbolImage
                    }
                }
            }
        }
    }
    
    var checkMarkSFSymbolImage: some View {
        Image(systemName: "checkmark")
            .font(.title3)
    }
}

// MARK: - PREVIEW

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView(
            .constant(0.0),
            selectedBookSortType: .constant(.latestOrder)
        )
    }
}
