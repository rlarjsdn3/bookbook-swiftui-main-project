//
//  TargetBookCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct HomeReadingBookButton: View {
    
    // MARK: - WRAPPER PROPERTIE
    
    @State private var isPresentingReadingBookView = false
    
    // MARK: - PROPERTIES
    
    let readingBook: CompleteBook
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook) {
        self.readingBook = completeBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        readingBookButton
    }
}

extension HomeReadingBookButton {
    var readingBookButton: some View {
        NavigationLink {
            CompleteBookView(readingBook)
        } label: {
            readingBookLabel
        }
        .buttonStyle(.plain)
    }
    
    var readingBookLabel: some View {
        VStack {
            asyncCoverImage(readingBook.cover)
                .overlay {
                    if readingBook.isBehindTargetDate && !readingBook.isComplete {
                        exclamationMarkSFSymbolImage
                    }
                }
            
            if !readingBook.isComplete {
                progressBar
            }
            
            titleText
            
            authorText
        }
    }
    
    var exclamationMarkSFSymbolImage: some View {
        Image(systemName: "exclamationmark.circle.fill")
            .font(.system(size: 50))
            .foregroundColor(Color.red)
            .frame(width: 150, height: 200)
            .background(
                Color.gray.opacity(0.15),
                in: RoundedRect(byRoundingCorners: [.allCorners])
            )
    }
    
    var progressBar: some View {
        HStack {
            let readingRate = readingBook.readingProgressRate
            let format = readingRate.formatted(.number.precision(.fractionLength(0)))
            
            ProgressView(value: readingRate, total: 100.0)
                .tint(Color.black.gradient)
                .frame(width: 100, alignment: .leading)
            
            Text("\(format)%")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    var titleText: some View {
        Text("\(readingBook.title)")
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: 150, height: 25)
            .padding(.horizontal)
            .padding([!readingBook.isComplete ? .top : [], .bottom], -5)
    }
    
    var authorText: some View {
        Text("\(readingBook.author)")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
    }
}

#Preview {
    HomeReadingBookButton(CompleteBook.preview)
}
