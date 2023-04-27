//
//  HomeTargetBookDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct HomeTargetBookDetailView: View {
    @ObservedRealmObject var targetBook: CompleteTargetBook
    
    var body: some View {
        Text("\(targetBook.title)")
    }
}

struct HomeTargetBookDetailView_Previews: PreviewProvider {
    @ObservedResults(CompleteTargetBook.self) static var completeTargetBooks
    
    static var previews: some View {
        HomeTargetBookDetailView(targetBook: completeTargetBooks[0])
    }
}
