//
//  ActivityCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/12.
//

import SwiftUI
import RealmSwift

struct ActivityCellView: View {
    @ObservedResults(ReadingBook.self) var readingBooks
    
    let activity: Activity
    
    var body: some View {
        NavigationLink {
            if let readingBook = readingBooks.first(where: {
                $0.isbn13 == activity.isbn13
            }) {
                ReadingBookView(readingBook: readingBook)
            }
            
        } label: {
            HStack {
                Image(systemName: "book.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(activity.category.accentColor)
                
                VStack(alignment: HorizontalAlignment.leading, spacing: 2) {
                    Text(activity.title)
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    HStack(alignment: VerticalAlignment.firstTextBaseline) {
                        Text("\(activity.numOfPagesRead)페이지 읽음")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(activity.category.accentColor)
                        
                        Spacer()
                        
                        Group {
                            Text("\(activity.date.formatted(date: .abbreviated , time: .omitted))")
                            
                            Image(systemName: "chevron.right")
                        }
                        .font(.caption)
                        .foregroundColor(Color.secondary)
                    }
                }
                
            }
            .padding(.vertical, 13)
            .padding(.horizontal)
            .background(Color("Background"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 13)
        }
        .buttonStyle(.plain)
    }
}

struct ActivityCellView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCellView(activity: Activity.preview)
    }
}
