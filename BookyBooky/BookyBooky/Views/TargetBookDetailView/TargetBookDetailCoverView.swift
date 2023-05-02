//
//  TargetBookDetailCoverView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/01.
//

import SwiftUI
import SwiftDate
import RealmSwift

struct TargetBookDetailCoverView: View {
    let readingBook: ReadingBook
    
    var body: some View {
        HStack {
            bookCoverImage(url: readingBook.cover)
            
            bookKeyInformation
            
            Spacer()
        }
        .frame(height: 200)
        
    }
}

extension TargetBookDetailCoverView {
    func bookCoverImage(url: String) -> some View {
        AsyncImage(url: URL(string: url),
                   transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 180)
                    .clipShape(
                        CoverShape()
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
            .frame(width: 130, height: 180)
            .shimmering()
    }
}

extension TargetBookDetailCoverView {
    var bookKeyInformation: some View {
        VStack(alignment: .leading, spacing: 3) {
            bookTitle
            
            bookSubInformation
            
            Spacer()
            
            bookProgressView
        }
        .padding()
    }
    
    var bookTitle: some View {
        Text(readingBook.title)
            .font(.title3.weight(.bold))
            .lineLimit(1)
            .truncationMode(.middle)
    }
    
    var bookSubInformation: some View {
        VStack(alignment: .leading) {
            Text(readingBook.author)
                .font(.body.weight(.semibold))
            
            Text("\(readingBook.publisher) ・ \(readingBook.category.rawValue)")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
    
    var bookProgressView: some View {
        HStack {
            VStack(alignment: .leading) {
                progressLabel
                
                readingTodayLabel
            }
            
            Spacer()
        
            progressGuage
        }
    }
    
    var progressLabel: some View {
        HStack {
            Text("50")
                .font(.largeTitle)
            
            Text("/")
                .font(.title2.weight(.light))
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading) {
                Text("\(readingBook.itemPage)")
                    .font(.callout).foregroundColor(.secondary)
                    .minimumScaleFactor(0.5)
                
                Text("페이지")
                    .font(.system(size: 11)).foregroundColor(.secondary)
            }
        }
    }
    
    var readingTodayLabel: some View {
        Text("오늘 10페이지 읽음")
            .font(.caption2.weight(.light))
            .foregroundColor(.secondary)
    }
    
    var progressGuage: some View {
        Gauge(value: 0.5) {
            Text("Label")
        } currentValueLabel: {
            Text("50%")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .scaleEffect(1.2)
        .tint(readingBook.category.accentColor.gradient)
        .gaugeStyle(.accessoryCircularCapacity)
    }
}

struct TargetBookDetailCoverView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var completeTargetBooks
    
    static var previews: some View {
        TargetBookDetailCoverView(readingBook: completeTargetBooks[0])
    }
}
