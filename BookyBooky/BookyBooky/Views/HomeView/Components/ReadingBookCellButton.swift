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
    
    @ObservedRealmObject var readingBook: ReadingBook
    let buttonType: ReadingBookCellButtonType
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook, buttonType: ReadingBookCellButtonType) {
        self.readingBook = readingBook
        self.buttonType = buttonType
    }
    
    // MARK: - BODY
    
    var body: some View {
        navigationCellButton
    }
}

extension ReadingBookCellButton {
    var navigationCellButton: some View {
        NavigationLink {
            ReadingBookView(readingBook)
        } label: {
            readingBookCellLabel
        }
        .buttonStyle(.plain)
    }
    
    var readingBookCellLabel: some View {
        VStack {
            ZStack {
                asyncCoverImage(
                    readingBook.cover,
                    width: 150, height: 200,
                    coverShape: RoundedCoverShape()
                )
                
                exclamationMarkSFSymbolImage
            }
            
            progressBar
            
            readingBookTitleText
            
            readingBookAuthorText
        }
//        .padding(.horizontal, 10)
    }
    
    var exclamationMarkSFSymbolImage: some View {
        Group {
            if readingBook.isBehindTargetDate {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color.red)
                    .frame(width: 150, height: 200)
                    .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 25))
            }
        }
    }
    
    var progressBar: some View {
        Group {
            if buttonType == .home {
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
        ReadingBookCellButton(ReadingBook.preview, buttonType: .home)
    }
}
