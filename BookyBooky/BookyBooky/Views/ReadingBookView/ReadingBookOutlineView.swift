//
//  outlineView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct ReadingBookOutlineView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedRealmObject var readingBook: CompleteBook
    
    // MARK: - BODY
    
    var body: some View {
        outlineContent
    }
}

// MARK: - EXTENSIONS

extension ReadingBookOutlineView {
    var outlineContent: some View {
        VStack {
            bookInfoTable
            
            Divider()
            
            bookDescLabel
            
            dbProviderLabel
        }
        .padding(.bottom, 40)
    }
    
    var bookInfoTable: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("기본 정보")
                .font(.headline.weight(.bold))
            
            Divider()
            
            HStack {
                Text("시작 날짜")
                    .font(.subheadline.weight(.medium))
                
                Spacer()
                
                Text("\(readingBook.startDate.standardDateFormat)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 1)
            
            HStack {
                Text("완독 날짜")
                    .font(.subheadline.weight(.medium))
                
                Spacer()
                
                Text("\(readingBook.completeDate?.standardDateFormat ?? "-")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 1)
            
            HStack {
                Text("목표 날짜")
                    .font(.subheadline.weight(.medium))
                
                Spacer()
                
                Text("\(readingBook.targetDate.standardDateFormat)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 1)
            
            Divider()
            
            HStack {
                Text("출판일")
                    .font(.subheadline.weight(.medium))
                
                Spacer()
                
                Text("\(readingBook.pubDate.standardDateFormat)")
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
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.background), in: .rect(cornerRadius: 15))
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    var bookDescLabel: some View {
        VStack {
            HStack {
                aboutBookText
                
                Spacer()
                
                moreLinkButton
            }
            .padding(.vertical, 3)
            .padding(.horizontal)
            
            bookDescText
        }
        .padding(.bottom, 20)
    }
    
    var aboutBookText: some View {
        Text("이 책에 관하여")
            .font(.title3.weight(.bold))
    }
    
    var moreLinkButton: some View {
        Group {
            if let url = URL(string: readingBook.link) {
                Link("자세히 보기", destination: url)
            }
        }
    }
    
    var bookDescText: some View {
        Text(readingBook.bookDescription)
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var dbProviderLabel: some View {
        HStack(spacing: 0) {
            Text("도서 DB 제공 : ")
            
            Link("알라딘 인터넷 서점", destination: URL(string: "https://www.aladin.co.kr")!)
        }
        .font(.caption)
    }
}

// MARK: - PREVIEW

struct ReadingBookOutlineView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookOutlineView(readingBook: CompleteBook.preview)
    }
}
