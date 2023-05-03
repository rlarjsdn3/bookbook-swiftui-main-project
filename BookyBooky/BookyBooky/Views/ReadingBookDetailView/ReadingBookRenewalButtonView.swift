//
//  ReadingBookRenewalButtonView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct ReadingBookRenewalButtonView: View {
    let readingBook: ReadingBook
    
    var body: some View {
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
            
            // 코드 미완성
            Text("\(Text("기한: ").fontWeight(.semibold))\(readingBook.targetDate.toFormat("yyyy년 M월 d일")) (7일 남음)")
                .font(.caption.weight(.light))
                .padding(.horizontal)
            

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .bottom])
    }
}

struct ReadingBookRenewalButtonView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        ReadingBookRenewalButtonView(readingBook: readingBooks[0])
    }
}
