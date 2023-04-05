//
//  HomeHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct HomeHeaderView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var bookDetailsISBN13 = ""
    @State private var showSearchSheetView = false
    
    // MARK: - BODY
    
    var body: some View {
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
            Button {
                
            } label: {
                profileImage
            }

        }
        .sheet(isPresented: $showSearchSheetView) {
            SearchSheetView(bookDetailsISBN13: $bookDetailsISBN13)
        }
        .foregroundColor(.black)
        .padding()
    }
}

// MARK: - EXTENSIONS

extension HomeHeaderView {
    var searchImage: some View {
        Image(systemName: "plus")
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    var profileImage: some View {
        Image(systemName: "person.crop.circle")
            .font(.title2)
            .fontWeight(.semibold)
    }
}

// MARK: - PREVIEW

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView()
    }
}
