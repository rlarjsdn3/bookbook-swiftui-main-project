//
//  outlineView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct CompleteBookOutlineView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedRealmObject var completeBook: CompleteBook
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook) {
        self.completeBook = completeBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        outlineContent
    }
}

// MARK: - EXTENSIONS

extension CompleteBookOutlineView {
    var outlineContent: some View {
        VStack {
            infoTable
            
            Divider()
            
            descriptionLabel
            
            dbProviderLabel
        }
        .padding(.bottom, 40)
    }
    
    var infoTable: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("기본 정보")
                .font(.headline.weight(.bold))
            
            Divider()
            
            startDateLabel
            
            completeDateLabel
            
            targetDateLabel
            
            Divider()
            
            publishDateLabel
            
            bookPageLabel
            
            bookIsbn13Label
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.customBackground, in: RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    var startDateLabel: some View {
        HStack {
            Text("시작 날짜")
                .font(.subheadline.weight(.medium))
            
            Spacer()
            
            Text("\(completeBook.startDate.standardDateFormat)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 1)
    }
    
    var completeDateLabel: some View {
        HStack {
            Text("완독 날짜")
                .font(.subheadline.weight(.medium))
            
            Spacer()
            
            Text("\(completeBook.completeDate?.standardDateFormat ?? "-")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 1)
    }
    
    var targetDateLabel: some View {
        HStack {
            Text("목표 날짜")
                .font(.subheadline.weight(.medium))
            
            Spacer()
            
            Text("\(completeBook.targetDate.standardDateFormat)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 1)
    }
    
    var publishDateLabel: some View {
        HStack {
            Text("출판일")
                .font(.subheadline.weight(.medium))
            
            Spacer()
            
            Text("\(completeBook.pubDate.standardDateFormat)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 1)
    }
    
    var bookPageLabel: some View {
        HStack {
            Text("쪽수")
                .font(.subheadline.weight(.medium))
            
            Spacer()
            
            Text("\(completeBook.itemPage)페이지")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 1)
    }
    
    var bookIsbn13Label: some View {
        HStack {
            Text("ISBN-13")
                .font(.subheadline.weight(.medium))
            
            Spacer()
            
            Text("\(completeBook.isbn13)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 1)
    }
    
    var descriptionLabel: some View {
        VStack {
            HStack {
                aboutBookText
                
                Spacer()
                
                moreLinkButton
            }
            .padding(.vertical, 3)
            .padding(.horizontal)
            
            descriptionText
        }
        .padding(.bottom, 20)
    }
    
    var aboutBookText: some View {
        Text("이 책에 관하여")
            .font(.title3.weight(.bold))
    }
    
    var moreLinkButton: some View {
        Group {
            if let url = URL(string: completeBook.link) {
                Link("자세히 보기", destination: url)
            }
        }
    }
    
    var descriptionText: some View {
        Text(completeBook.bookDescription)
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
        CompleteBookOutlineView(CompleteBook.preview)
    }
}
