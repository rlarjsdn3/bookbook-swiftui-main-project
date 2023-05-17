//
//  TargetBookDetailCoverView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/01.
//

import SwiftUI
import RealmSwift

struct ReadingBookCoverView: View {
    let readingBook: ReadingBook
    
    @State private var isPresentingRenewalSheet = false
    @State private var isPresentingCompleteConfettiView = false
    
    // MARK: - COMPUTED PROPERTIES
    
    var readingBookProgressRate: Double {
        if let readingRecord = readingBook.readingRecords.last {
            return (Double(readingRecord.totalPagesRead) / Double(readingBook.itemPage)) * 100.0
        } else {
            return 0.0
        }
    }
    
    var readingBookProgressPage: Int {
        if let readingRecord = readingBook.readingRecords.last {
            return readingRecord.totalPagesRead
        } else {
            return 0
        }
    }
    
    var isAscendingTargetDate: Bool {
        let result = Date.now.compare(readingBook.targetDate)
        
        switch result {
        case .orderedAscending, .orderedSame:
            return true
        case .orderedDescending:
            return false
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    bookCoverImage(url: readingBook.cover)
                    
                    if !isAscendingTargetDate {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color.red)
                            .frame(width: 130, height: 180)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(CoverShape())
                    }
                }
                
                bookKeyInformation
                
                Spacer()
            }
            .frame(height: 200)
            
            HStack {
                Button {
                    isPresentingRenewalSheet = true
                } label: {
                    Group {
                        if readingBook.isComplete {
                            Text("완독 도서")
                        } else {
                            if isAscendingTargetDate {
                                Text("읽었어요!")
                            } else {
                                Text("갱신 불가")
                                    .opacity(0.75)
                            }
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 112, height: 30)
                    .background(.gray.opacity(0.3))
                    .clipShape(Capsule())
                }
                .disabled(!isAscendingTargetDate)
                .disabled(readingBook.isComplete)
                
                // 코드 미완성 (오늘 상태 메시지 출력하기)
                if readingBook.isComplete {
                    Text("도서를 완독했어요!")
                        .font(.caption.weight(.light))
                        .padding(.horizontal)
                } else {
                    if isAscendingTargetDate {
                        if let lastRecord = readingBook.readingRecords.last {
                            let calendar = Calendar.current
                            
                            let components1 = calendar.dateComponents([.year, .month, .day], from: lastRecord.date)
                            let components2 = calendar.dateComponents([.year, .month, .day], from: Date.now)
                            
                            if components1.year == components2.year && components1.month == components2.month && components1.day == components2.day {
                                Text("오늘 \(lastRecord.numOfPagesRead)페이지나 읽었어요!")
                                    .font(.caption.weight(.light))
                                    .padding(.horizontal)
                            } else {
                                Text("독서를 시작해보세요!")
                                    .font(.caption.weight(.light))
                                    .padding(.horizontal)
                            }
                        } else {
                            Text("독서를 시작해보세요!")
                                .font(.caption.weight(.light))
                                .padding(.horizontal)
                        }
                    } else {
                        Text("목표를 다시 설정해주세요!")
                            .font(.caption.weight(.light))
                            .padding(.horizontal)
                    }
                }
            }
            .sheet(isPresented: $isPresentingRenewalSheet) {
                ReadingBookRenewalView(readingBook: readingBook, isPresentingConfettiView: $isPresentingCompleteConfettiView)
            }
            .fullScreenCover(isPresented: $isPresentingCompleteConfettiView) {
                CompleteConfettiView(readingBook: readingBook)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .bottom])
        }
        
    }
}

// MARK: - EXTENSIONS

extension ReadingBookCoverView {
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

extension ReadingBookCoverView {
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
            progressLabel
            
            Spacer()
        
            progressGuage
        }
    }
    
    var progressLabel: some View {
        HStack {
            Text("\(readingBookProgressPage)")
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
    
    var progressGuage: some View {
        Gauge(value: readingBookProgressRate, in: 0...100) {
            Text("Label")
        } currentValueLabel: {
            Text("\(readingBookProgressRate.formatted(.number.precision(.fractionLength(0))))%")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .scaleEffect(1.2)
        .tint(readingBook.category.accentColor.gradient)
        .gaugeStyle(.accessoryCircularCapacity)
    }
}

struct TargetBookDetailCoverView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookCoverView(readingBook: ReadingBook.preview)
    }
}
