//
//  TargetBookDetailCoverView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/01.
//

import SwiftUI
import RealmSwift

struct ReadingBookInfoView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var isPresentingRenewalSheet = false
    @State private var isPresentingReadingBookConfettiView = false
   
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    // MARK: - INITIALIZER
    
    init(_ readingBook: ReadingBook) {
        self.readingBook = readingBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        readingBookInfo
            .sheet(isPresented: $isPresentingRenewalSheet) {
                ReadingBookRenewalSheetView(
                    readingBook,
                    isPresentingReadingBookConfettiView: $isPresentingReadingBookConfettiView
                )
            }
            .fullScreenCover(isPresented: $isPresentingReadingBookConfettiView) {
                ReadingBookConfettiView(readingBook)
            }
    }
}

// MARK: - EXTENSIONS

extension ReadingBookInfoView {
    var readingBookInfo: some View {
        VStack {
            readingBookCover
            
            readingStatusButton
        }
    }
    
    var readingBookCover: some View {
        HStack {
            ZStack {
                asyncCoverImage(
                    readingBook.cover,
                    width: 130, height: 180,
                    coverShape: CoverShape()
                )
                
                exclamationMarkSFSymbolImage
            }
            
            readingBookInfoLabel
        }
        .frame(height: 180)
    }
    
    var readingStatusButton: some View {
        HStack {
            readingButton
            
            readingStatusText
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
    }
    
    var exclamationMarkSFSymbolImage: some View {
        Group {
            if readingBook.isBehindTargetDate {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color.red)
                    .frame(width: 130, height: 180)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(CoverShape())
            }
        }
    }
    
    var readingBookInfoLabel: some View {
        VStack(alignment: .leading, spacing: 3) {
            readingbBookTitleText
            
            readingBookSubInfoLabel
            
            Spacer()
            
            readingBookProgressLabel
        }
        .padding()
    }
    
    var readingbBookTitleText: some View {
        Text(readingBook.title)
            .font(.title3.weight(.bold))
            .lineLimit(1)
            .truncationMode(.middle)
    }
    
    var readingBookSubInfoLabel: some View {
        VStack(alignment: .leading) {
            Text(readingBook.author)
                .font(.body.weight(.semibold))
            
            Text("\(readingBook.publisher) ・ \(readingBook.category.rawValue)")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
    
    var readingBookProgressLabel: some View {
        HStack {
            progressLabel
            
            Spacer()
        
            progressGuage
        }
    }
    
    var progressLabel: some View {
        HStack {
            Text("\(readingBook.readingProgressPage)")
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
        Group {
            let readingProgressRate = readingBook.readingProgressRate
            
            Gauge(value: readingProgressRate, in: 0...100) {
                Text("ReadingProgressRate")
            } currentValueLabel: {
                Text("\(readingProgressRate.formatted(.number.precision(.fractionLength(0))))%")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .tint(readingBook.category.accentColor.gradient)
            .gaugeStyle(.accessoryCircularCapacity)
            .padding(10)
        }
    }
}

extension ReadingBookInfoView {
    var readingButton: some View {
        Button {
            isPresentingRenewalSheet = true
        } label: {
            Group {
                if readingBook.isComplete {
                    Text("완독 도서")
                } else {
                    if readingBook.isBehindTargetDate {
                        Text("갱신 불가")
                            .opacity(0.75)
                    } else {
                        Text("읽었어요!")
                    }
                }
            }
            .font(.headline)
            .foregroundColor(.black)
            .frame(width: 112, height: 30)
            .background(.gray.opacity(0.3))
            .clipShape(Capsule())
        }
        .disabled(readingBook.isComplete)
        .disabled(readingBook.isBehindTargetDate)
    }
    
    var readingStatusText: some View {
        Group {
            if readingBook.isComplete {
                Text("도서를 완독했어요!")
            } else {
                Group {
                    // 오늘 일자가 목표 일자를 초과하는 경우
                    if readingBook.isBehindTargetDate {
                        Text("목표를 다시 설정해주세요!")
                        // 오늘 일자가 목표 일자와 같거나 더 빠른 경우
                    } else {
                        // 독서 데이터가 하나라도 존재하는 경우
                        if let lastRecord = readingBook.lastRecord {
                            // 오늘 일자에 독서를 한 경우
                            if Date().isEqual([.year, .month, .day], date: lastRecord.date) {
                                Text("오늘 \(lastRecord.numOfPagesRead)페이지나 읽었어요!")
                                // 오늘 일자에 독서를 하지 않은 경우
                            } else {
                                Text("독서를 시작해보세요!")
                            }
                            // 독서 데이터가 없는 경우
                        } else {
                            Text("독서를 시작해보세요!")
                        }
                    }
                }
                .font(.caption.weight(.light))
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - PREVIEW

struct ReadingBookInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookInfoView(ReadingBook.preview)
            .environmentObject(RealmManager())
    }
}
