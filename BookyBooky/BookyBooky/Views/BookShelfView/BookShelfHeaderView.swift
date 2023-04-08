//
//  BookShelfHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI

struct BookShelfHeaderView: View {
    @Binding var scrollYOffset: CGFloat
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("책장")
                .font(.title2)
                .fontWeight(.semibold)
                .opacity(scrollYOffset > 30.0 ? 1 : 0)
            
            Spacer()
        }
        .overlay(alignment: .trailing) {
            Button {
                
            } label: {
                Image(systemName: "text.book.closed.fill")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(25)
            }

        }
        .padding(.vertical)
    }
}

struct BookShelfHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfHeaderView(scrollYOffset: .constant(0.0))
    }
}
