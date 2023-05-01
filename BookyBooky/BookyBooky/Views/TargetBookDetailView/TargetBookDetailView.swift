//
//  HomeTargetBookDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct TargetBookDetailView: View {
    @ObservedRealmObject var targetBook: CompleteTargetBook
    
    var body: some View {
        VStack(spacing: 0) {
            TargetBookDetailHeaderView(targetBook: targetBook)
            
            ScrollView {
                TargetBookDetailCoverView(targetBook: targetBook)
                
                HStack {
                    Button {
                        // do something...
                    } label: {
                        Text("읽었어요!")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 112, height: 30)
                            .background(.gray.opacity(0.3))
                            .clipShape(Capsule())
                    }
                    
                    Text("오늘 히루 10페이지를 읽었어요!")
                        .font(.caption.weight(.light))
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Spacer()
            }
            
            
            
//            Text("\(targetBook.title)")
//                .toolbar(.hidden, for: .navigationBar)
//
//            // 테스트 코드
//            Button("10페이지 읽었음!") {
//                let readingRecord = ReadingRecords(
//                    value: ["date": Date(),
//                            "totalPagesRead": 10,
//                            "numOfPagesRead": 10] as [String : Any]
//                )
//
//                $targetBook.readingRecords.append(readingRecord)
//            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension TargetBookDetailView {
    
}

struct HomeTargetBookDetailView_Previews: PreviewProvider {
    static let realmManager = RealmManager.openLocalRealm()
    @ObservedResults(CompleteTargetBook.self) static var completeTargetBooks
    
    static var previews: some View {
        TargetBookDetailView(targetBook: completeTargetBooks[0])
    }
}
