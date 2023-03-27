//
//  HomeHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/27.
//

import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            Menu {
                Button {
                    // do somethings...
                } label: {
                    Label("직접 추가", systemImage: "pencil.line")
                }
                
                Button {
                    // do somethings...
                } label: {
                    Label("검색 추가", systemImage: "magnifyingglass")
                }
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "person.crop.circle")
                    .font(.title)
                    .fontWeight(.bold)
            }

        }
        .foregroundColor(.black)
        .padding()
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView()
    }
}
