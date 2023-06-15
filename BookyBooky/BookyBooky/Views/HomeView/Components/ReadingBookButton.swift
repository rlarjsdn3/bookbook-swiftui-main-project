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

struct ReadingBookButton: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isPresentingReadingBookView = false
    
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var readingBook: ReadingBook
    let buttonType: ReadingBookCellButtonType
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook, buttonType: ReadingBookCellButtonType) {
        self.readingBook = readingBook
        self.buttonType = buttonType
    }
    
    // MARK: - BODY
    
    var body: some View {
        readingBookButton
    }
}

extension ReadingBookButton {
    var readingBookButton: some View {
        NavigationLink {
            ReadingBookView(readingBook)
        } label: {
            readingBookGridLabel
        }
        .buttonStyle(.plain)
    }
    
    var readingBookGridLabel: some View {
        VStack {
            asyncCoverImage(
                readingBook.cover,
                width: 150, height: 200,
                coverShape: RoundedRect()
            )
            .overlay {
                if readingBook.isBehindTargetDate {
                    exclamationMarkSFSymbolImage
                }
            }
            
            if buttonType == .home {
                progressBar
            }
            
            readingBookTitleText
            
            readingBookAuthorText
        }
    }
    
    var exclamationMarkSFSymbolImage: some View {
        Image(systemName: "exclamationmark.circle.fill")
            .font(.system(size: 50))
            .foregroundColor(Color.red)
            .frame(width: 150, height: 200)
            .background(
                Color.gray.opacity(0.15),
                in: .rect(cornerRadius: 25)
            )
    }
    
    var progressBar: some View {
        HStack {
            let progressRatio = readingBook.readingProgressRate
            
            ProgressView(value: progressRatio, total: 100.0)
                .tint(Color.black.gradient)
                .frame(width: 100, alignment: .leading)
            
            Text("\(progressRatio.formatted(.number.precision(.fractionLength(0))))%")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    var readingBookTitleText: some View {
        Text("\(readingBook.title)")
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: 150, height: 25)
            .padding(.horizontal)
            .padding([buttonType == .home ? .top : [], .bottom], -5)
    }
    
    var readingBookAuthorText: some View {
        Text("\(readingBook.author)")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
    }
}

struct ReadingBookCellButton_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookButton(ReadingBook.preview, buttonType: .home)
    }
}
