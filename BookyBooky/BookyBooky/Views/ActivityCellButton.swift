//
//  ActivityCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/12.
//

import SwiftUI
import RealmSwift

struct ActivityCellButton: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    @ObservedResults(ReadingBook.self) var readingBooks
    
    // MARK: - PROPERTIES
    
    let activity: Activity
    
    // MARK: - INITALIZER
    
    init(_ activity: Activity) {
        self.activity = activity
    }
    
    // MARK: - BODY
    
    var body: some View {
        navigationButton
    }
}

// MARK: - EXTENSIONS

extension ActivityCellButton {
    var navigationButton: some View {
        NavigationLink {
            if let book = realmManager.findReadingBookFirst(with: activity.isbn13) {
                ReadingBookView(readingBook: book)
            }
        } label: {
            cellLabel
        }
        .buttonStyle(.plain)
    }
    
    var cellLabel: some View {
        HStack {
            statusImage
            
            statusLabel
        }
        .padding(.vertical, 13)
        .padding(.horizontal)
        .background(Color("Background"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 13)
    }
    
    var statusImage: some View {
        Group {
            // 도서를 완독한 경우
            if activity.isComplete {
                Image(systemName: "book.closed.circle.fill")
            // 도서를 완독하지 않은 경우 (읽고 있는 중인 경우)
            } else {
                Image(systemName: "book.circle.fill")
            }
        }
        .font(.largeTitle)
        .foregroundColor(activity.category.accentColor)
    }
    
    var statusLabel: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 2) {
            bookTitleText
            
            HStack(alignment: VerticalAlignment.firstTextBaseline) {
                numOfPagesReadText
                
                Spacer()
                
                readingDateText
            }
        }
    }
    
    var bookTitleText: some View {
        Text(activity.title)
            .font(.subheadline)
            .foregroundColor(Color.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
    
    var numOfPagesReadText: some View {
        Group {
            if activity.isComplete {
                Text("완독함")
            } else {
                Text("\(activity.numOfPagesRead)페이지 읽음")
            }
        }
        .font(.title3.weight(.semibold))
        .foregroundColor(activity.category.accentColor)
    }
    
    var readingDateText: some View {
        Group {
            Text(activity.date.toFormat("yyyy. M. d."))
            
            Image(systemName: "chevron.right")
        }
        .font(.caption)
        .foregroundColor(Color.secondary)
    }
}

struct ActivityCellButton_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCellButton(Activity.preview)
            .environmentObject(RealmManager())
    }
}