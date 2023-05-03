//
//  TargetBookCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct ReadingBookCellView: View {
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var isPresentingReadingBookView = false
    
    // MARK: - COMPUTED PROPERTIES
    
    var readingBookProgressValue: Double {
        if let readingRecord = readingBook.readingRecords.last {
            return Double(readingRecord.totalPagesRead) / Double(readingBook.itemPage)
        } else {
            return 0.0
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            asyncImage(url: readingBook.cover)

            progressBar
            
            targetBookTitle
            
            targetBookAuthor
        }
        .frame(width: 150)
        .padding(.horizontal, 10)
        .navigationDestination(isPresented: $isPresentingReadingBookView) {
            ReadingBookView(readingBook: readingBook)
        }
        .onTapGesture {
            isPresentingReadingBookView = true
        }
    }
}

extension ReadingBookCellView {
    func asyncImage(url: String) -> some View {
        AsyncImage(url: URL(string: url),
                   transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 200)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 15,
                            style: .continuous
                        )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: -5, y: 5)
            case .failure(_), .empty:
                loadingImage
            @unknown default:
                loadingImage
            }
        }
    }
    
    var loadingImage: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.gray.opacity(0.2))
            .frame(width: 150, height: 200)
            .shimmering()
    }
    
    var progressBar: some View {
        HStack {
            ProgressView(value: readingBookProgressValue, total: 100.0)
                .tint(Color.black.gradient)
                .frame(width: 100, alignment: .leading)
            
            Text("\(Int(readingBookProgressValue))%")
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
            .padding([.top, .bottom], -5)
    }
    
    var targetBookAuthor: some View {
        Text("\(readingBook.author)")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
    }
}

struct ReadingBookCellView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var completeTargetBooks
    
    static var previews: some View {
        ReadingBookCellView(readingBook: completeTargetBooks[0])
    }
}
