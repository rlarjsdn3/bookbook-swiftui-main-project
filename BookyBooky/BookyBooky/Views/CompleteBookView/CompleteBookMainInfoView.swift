//
//  TargetBookDetailCoverView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/01.
//

import SwiftUI
import AnimateNumberText
import RealmSwift

struct CompleteBookMainInfoView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    @EnvironmentObject var completeBookViewData: CompleteBookViewData
    
    @State private var isPresentingRenewalSheet = false
   
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var completeBook: CompleteBook
    
    // MARK: - INITIALIZER
    
    init(_ completeBook: CompleteBook) {
        self.completeBook = completeBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        bookInfo
            .sheet(isPresented: $isPresentingRenewalSheet) {
                CompleteBookRenewalSheetView(completeBook)
            }
            .fullScreenCover(isPresented: $completeBookViewData.isPresentingConfettiView) {
                CompleteBookConfettiView(completeBook)
            }
            .onAppear {
                completeBookViewData.pageRead = Double(completeBook.readingProgressPage)
            }
    }
}

// MARK: - EXTENSIONS

extension CompleteBookMainInfoView {
    var bookInfo: some View {
        VStack {
            infoLabel
            
            statusLabel
        }
    }
    
    var infoLabel: some View {
        HStack {
            ZStack {
                asyncCoverImage(
                    completeBook.cover,
                    width: 130, height: 180,
                    coverShape: RoundedRect(byRoundingCorners: [.topRight, .bottomRight])
                )
                
                if completeBook.isBehindTargetDate && !completeBook.isComplete {
                    exclamationMarkSFSymbolImage
                }
            }
            
            mainInfoLabel
        }
        .frame(height: 200)
    }
    
    var statusLabel: some View {
        HStack {
            renewalButton
            
            statusText
            
            Spacer()
        }
        .padding(.vertical, 5)
        .padding(.horizontal)
    }
    
    var renewalButton: some View {
        Button {
            isPresentingRenewalSheet = true
        } label: {
            Group {
                if completeBook.isComplete {
                    Text("완독 도서")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 112, height: 30)
                        .overlay {
                            Capsule()
                                .stroke(Color.black, lineWidth: 1.0)
                        }
                } else {
                    Group {
                        if completeBook.isBehindTargetDate {
                            Text("갱신 불가")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(width: 112, height: 30)
                                .overlay {
                                    Capsule()
                                        .stroke(Color.red, lineWidth: 1.0)
                                }
                        } else {
                            Text("읽었어요!")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(width: 112, height: 30)
                                .background(.gray.opacity(0.3))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .disabled(completeBook.isComplete)
        .disabled(completeBook.isBehindTargetDate)
    }
    
    var statusText: some View {
        Group {
            if completeBook.isComplete {
                Text("도서를 완독했어요!")
            } else {
                // 오늘 일자가 목표 일자를 초과하는 경우
                if completeBook.isBehindTargetDate {
                    Text("목표를 다시 설정해주세요!")
                    // 오늘 일자가 목표 일자와 같거나 더 빠른 경우
                } else {
                    // 독서 데이터가 하나라도 존재하는 경우
                    if let lastRecord = completeBook.lastRecord {
                        let today = Date()
                        // 오늘 일자에 독서를 한 경우
                        if today.isEqual([.year, .month, .day], with: lastRecord.date) {
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
        }
        .font(.caption.weight(.light))
        .padding(.horizontal)
    }
    
    var exclamationMarkSFSymbolImage: some View {
        Image(systemName: "exclamationmark.circle.fill")
            .font(.system(size: 50))
            .foregroundColor(Color.red)
            .frame(width: 130, height: 180)
            .background(
                Color.gray.opacity(0.15),
                in: RoundedRect(byRoundingCorners: [.topRight, .bottomRight])
            )
    }
    
    var mainInfoLabel: some View {
        VStack(alignment: .leading, spacing: 3) {
            bookTitleText
            
            subInfoLabel
            
            Spacer()
            
            progressLabel
        }
        .padding()
    }
    
    var bookTitleText: some View {
        Text(completeBook.title)
            .font(.title3.weight(.bold))
            .lineLimit(1)
            .truncationMode(.middle)
    }
    
    var subInfoLabel: some View {
        VStack(alignment: .leading) {
            Text(completeBook.author)
                .font(.body.weight(.semibold))
            
            Text("\(completeBook.publisher) ・ \(completeBook.category.name)")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
    
    var progressLabel: some View {
        HStack {
            progressText
            
            Spacer()
        
            progressGuage
        }
    }
    
    var progressText: some View {
        HStack {
            AnimateNumberText(font: .title, value: $completeBookViewData.pageRead, textColor: .constant(Color.black))
            
            HStack {
                Text("/")
                    .font(.title2.weight(.light))
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading) {
                    Text("\(completeBook.itemPage)")
                        .font(.callout).foregroundColor(.secondary)
                        .minimumScaleFactor(0.5)
                    
                    Text("페이지")
                        .font(.system(size: 11)).foregroundColor(.secondary)
                }
            }
        }
    }
    
    var progressGuage: some View {
        Group {
            let progressRate = completeBook.readingProgressRate
            
            Gauge(value: progressRate, in: 0...100) {
                Text("ReadingProgressRate")
            } currentValueLabel: {
                Text("\(progressRate.formatted(.number.precision(.fractionLength(0))))%")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .tint(completeBook.category.themeColor.gradient)
            .gaugeStyle(.accessoryCircularCapacity)
            .padding(10)
        }
    }
}

// MARK: - PREVIEW

#Preview {
    CompleteBookMainInfoView(CompleteBook.preview)
        .environmentObject(CompleteBookViewData())
        .environmentObject(RealmManager())
}
