//
//  outlineView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct ReadingBookOutlineView: View {
    let readingBook: ReadingBook
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("기본 정보")
                    .font(.headline.weight(.bold))
                
                Divider()
                
                HStack {
                    Text("출판일")
                        .font(.subheadline.weight(.bold))
                    
                    Spacer()
                    
                    Text("\(readingBook.pubDate.toFormat("yyyy년 M월 d일 (E요일)", locale: Locale(identifier: "ko_kr")))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 1)
                
                HStack {
                    Text("쪽수")
                        .font(.subheadline.weight(.bold))
                    
                    Spacer()
                    
                    Text("\(readingBook.itemPage)페이지")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 1)
                
                HStack {
                    Text("ISBN-13")
                        .font(.subheadline.weight(.bold))
                    
                    Spacer()
                    
                    Text("\(readingBook.isbn13)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color("Background"))
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
            
            VStack {
                HStack {
                    Text("이 책에 관하여")
                        .font(.title3.weight(.bold))
                    
                    Spacer()
                    
                    Link("자세히 보기", destination: URL(string: readingBook.link)!)
                }
                .padding([.top, .bottom], 3)
                .padding(.horizontal)
                
                Text(readingBook.explanation)
                    .padding(.horizontal)
            }
        }
//        .padding(.bottom, 40)
    }
}

struct ReadingBookOutlineView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        ReadingBookOutlineView(readingBook: readingBooks[0])
    }
}
