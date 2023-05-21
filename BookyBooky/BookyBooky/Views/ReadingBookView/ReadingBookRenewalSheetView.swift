//
//  ReadingBookRenewalView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/05.
//

import SwiftUI
import RealmSwift

struct ReadingBookRenewalSheetView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var realmManager: RealmManager
    
    
    @State private var totalPagesRead = 0
    
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var readingBook: ReadingBook
    @Binding var isPresentingReadingBookConfettiView: Bool
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook, isPresentingReadingBookConfettiView: Binding<Bool>) {
        self.readingBook = readingBook
        self._isPresentingReadingBookConfettiView = isPresentingReadingBookConfettiView
    }
    
    // MARK: - BODY
    
    var body: some View {
        renewalPageStatusLabel
            .onAppear {
                totalPagesRead = readingBook.lastRecord?.totalPagesRead ?? 0
            }
            .onDisappear {
                if readingBook.isComplete {
                    isPresentingReadingBookConfettiView = true
                }
            }
            .presentationCornerRadius(30)
            .presentationDetents([.height(400)])
    }
}

extension ReadingBookRenewalSheetView {
    var renewalPageStatusLabel: some View {
        VStack {
            howManyPagesDidYouReadText
            
            Spacer()
        
            totalPagesReadLabel
            
            Spacer()
            
            renewalButton
        }
    }
    
    var howManyPagesDidYouReadText: some View {
        Text("어디까지 읽으셨나요?")
            .font(.title.weight(.bold))
            .offset(y: 45)
    }
    
    var totalPagesReadLabel: some View {
        VStack {
            Text("\(totalPagesRead)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .padding(.vertical, 2)
            
            Text("페이지")
                .font(.title3.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
        .overlay {
            pageControlButtons
        }
        .padding()
    }
    
    var pageControlButtons: some View {
        HStack {
            minusButton
            
            Spacer()
            
            plusButton
        }
        .offset(y: -17)
        .padding()
    }
    
    
    var minusButton: some View {
        Group {
            let lastRecordTotalPagesRead = readingBook.lastRecord?.totalPagesRead ?? 0
            
            Button {
                totalPagesRead -= 1
            } label: {
                Image(systemName: "minus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.vertical, 23)
                    .padding(.horizontal)
                    .background(readingBook.category.accentColor)
                    .clipShape(Circle())
            }
            .opacity(lastRecordTotalPagesRead >= totalPagesRead  ? 0.5 : 1)
            .disabled(lastRecordTotalPagesRead >= totalPagesRead  ? true : false)
        }
    }
    
    var plusButton: some View {
        Group {
            let readingBookPage = readingBook.itemPage
            
            Button {
                totalPagesRead  += 1
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(readingBook.category.accentColor)
                    .clipShape(Circle())
            }
            .opacity(readingBookPage <= totalPagesRead  ? 0.5 : 1)
            .disabled(readingBookPage <= totalPagesRead  ? true : false)
        }
    }
    
    var renewalButton: some View {
        Button {
            realmManager.addReadingBookRecord(
                readingBook,
                totalPagesRead: totalPagesRead
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                dismiss()
            }
        } label: {
            Text("갱신하기")
        }
        .buttonStyle(.bottomButtonStyle)
    }
}

// MARK: - PREVIEW

struct ReadingBookRenewalSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookRenewalSheetView(
            ReadingBook.preview,
            isPresentingReadingBookConfettiView: .constant(false)
        )
        .environmentObject(RealmManager())
    }
}
