//
//  TargetBookCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

enum ReadingBookCellButtonType {
    case home
    case shelf
}

struct ReadingBookCellButton: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isPresentingReadingBookView = false
    
    // MARK: - PROPERTIES
    
    let readingBook: ReadingBook
    let buttonType: ReadingBookCellButtonType
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook, buttonType: ReadingBookCellButtonType) {
        self.readingBook = readingBook
        self.buttonType = buttonType
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationLink {
            ReadingBookView(readingBook: readingBook)
        } label: {
            VStack {
                ZStack {
                    asyncImage(
                        readingBook.cover,
                        width: 150, height: 200,
                        coverShape: RoundedRectangle(cornerRadius: 15)
                    )
                    
                    if readingBook.isBehindTargetDate {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color.red)
                            .frame(width: 150, height: 200)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 15,
                                    style: .continuous
                                )
                            )
                    }
                }
                
                if buttonType == .home {
                    progressBar
                }
                
                targetBookTitle
                
                targetBookAuthor
            }
            .padding(.horizontal, 10)
        }
        .buttonStyle(.plain)
    }
}

extension ReadingBookCellButton {
    var progressBar: some View {
        HStack {
            let readingProgressRate = readingBook.readingProgressRate
            
            ProgressView(value: readingProgressRate, total: 100.0)
                .tint(Color.black.gradient)
                .frame(width: 100, alignment: .leading)
            
            Text("\(readingProgressRate.formatted(.number.precision(.fractionLength(0))))%")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    var targetBookTitle: some View {
        Text("\(readingBook.title)")
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: 150, height: 25)
            .padding(.horizontal)
            .padding([buttonType == .home ? .top : [], .bottom], -5)
    }
    
    var targetBookAuthor: some View {
        Text("\(readingBook.author)")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
    }
}

struct ReadingBookCellButton_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookCellButton(ReadingBook.preview, buttonType: .home)
    }
}
