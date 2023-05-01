//
//  TargetBookDetailHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/01.
//

import SwiftUI
import RealmSwift

struct TargetBookDetailHeaderView: View {
    @Environment(\.dismiss) var dismiss
    
    let targetBook: CompleteTargetBook
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(targetBook.title)
                .frame(width: mainScreen.width * 0.65)
                .lineLimit(1)
                .truncationMode(.middle)
                .navigationTitleStyle()
            
            Spacer()
        }
        .overlay {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .navigationBarItemStyle()
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .navigationBarItemStyle()
                }
            }
        }
        .padding(.vertical)
    }
}

struct TargetBookDetailHeaderView_Previews: PreviewProvider {
    @ObservedResults(CompleteTargetBook.self) static var completeTargetBooks
    
    static var previews: some View {
        TargetBookDetailHeaderView(targetBook: completeTargetBooks[0])
    }
}
