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
                    Text("시작 날짜")
                        .font(.subheadline.weight(.medium))
                    
                    Spacer()
                    
                    Text("\(readingBook.startDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 1)
                
                HStack {
                    Text("완독 날짜")
                        .font(.subheadline.weight(.medium))
                    
                    Spacer()
                    
                    Text("\(readingBook.completeDate?.formatted(date: .abbreviated, time: .omitted) ?? "-")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 1)
                
                HStack {
                    Text("목표 날짜")
                        .font(.subheadline.weight(.medium))
                    
                    Spacer()
                    
                    Text("\(readingBook.targetDate.formatted(date: .abbreviated, time: .omitted)))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 1)
                
                Divider()
                
                HStack {
                    Text("출판일")
                        .font(.subheadline.weight(.medium))
                    
                    Spacer()
                    
                    Text("\(readingBook.pubDate.formatted(date: .abbreviated, time: .omitted)))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 1)
                
                HStack {
                    Text("쪽수")
                        .font(.subheadline.weight(.medium))
                    
                    Spacer()
                    
                    Text("\(readingBook.itemPage)페이지")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 1)
                
                HStack {
                    Text("ISBN-13")
                        .font(.subheadline.weight(.medium))
                    
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
                    
                    if let url = URL(string: readingBook.link) {
                        Link("자세히 보기", destination: url)
                    }
                }
                .padding([.top, .bottom], 3)
                .padding(.horizontal)
                
                Text(readingBook.explanation)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
            
            HStack(spacing: 0) {
                Text("도서 DB 제공 : ")
                
                Link("알라딘 인터넷 서점", destination: URL(string: "https://www.aladin.co.kr")!)
            }
            .font(.caption)
        }
        .padding(.bottom, 40)
    }
}

struct ReadingBookOutlineView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookOutlineView(readingBook: ReadingBook.preview)
    }
}
