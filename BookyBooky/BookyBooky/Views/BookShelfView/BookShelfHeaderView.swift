//
//  BookShelfHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI

struct BookShelfHeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            
            Text("책장")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
        }
        .padding()
    }
}

struct BookShelfHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfHeaderView()
    }
}
