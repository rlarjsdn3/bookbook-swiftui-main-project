//
//  TargetBookCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct CompleteBookButton: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isPresentingReadingBookView = false
    
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var readingBook: CompleteBook
    let type: ButtonType.CompleteBookButton
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: CompleteBook, type: ButtonType.CompleteBookButton) {
        self.readingBook = readingBook
        self.type = type
    }
    
    // MARK: - BODY
    
    var body: some View {
        compBookButton
    }
}

extension CompleteBookButton {
    var compBookButton: some View {
        NavigationLink {
            CompleteBookView(readingBook)
        } label: {
            compBookLabel
        }
        .buttonStyle(.plain)
    }
    
    var compBookLabel: some View {
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
            
            if type == .home {
                progressBar
            }
            
            compBookTitleText
            
            compBookAuthorText
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
    
    var compBookTitleText: some View {
        Text("\(readingBook.title)")
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: 150, height: 25)
            .padding(.horizontal)
            .padding([type == .home ? .top : [], .bottom], -5)
    }
    
    var compBookAuthorText: some View {
        Text("\(readingBook.author)")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
    }
}

#Preview {
    CompleteBookButton(.preview, type: .home)
}
