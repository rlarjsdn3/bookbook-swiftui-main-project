//
//  ReadingBookRenewalView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/05.
//

import SwiftUI
import RealmSwift

struct CompleteBookRenewalSheetView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var totalPagesRead = 0
    
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var completeBook: CompleteBook
    @Binding var readingProgressPage: Double
    @Binding var isPresentingReadingBookConfettiView: Bool
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook,
         readingProgressPage: Binding<Double>,
         isPresentingReadingBookConfettiView: Binding<Bool>) {
        self.completeBook = completeBook
        self._readingProgressPage = readingProgressPage
        self._isPresentingReadingBookConfettiView = isPresentingReadingBookConfettiView
    }
    
    // MARK: - BODY
    
    var body: some View {
        renewalContent
            .onAppear {
                totalPagesRead = completeBook.lastRecord?.totalPagesRead ?? 0
            }
            .onDisappear {
                if completeBook.isComplete {
                    isPresentingReadingBookConfettiView = true
                }
            }
            .presentationCornerRadius(30)
            .presentationDetents([.height(400)])
    }
}

extension CompleteBookRenewalSheetView {
    var renewalContent: some View {
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
            .padding(.top, 45)
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
            pageControlButtonGroup
        }
        .padding()
    }
    
    var pageControlButtonGroup: some View {
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
            let lastRecordTotalPagesRead = completeBook.lastRecord?.totalPagesRead ?? 0
            
            Button {
                totalPagesRead -= 1
            } label: {
                Image(systemName: "minus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.vertical, 23)
                    .padding(.horizontal)
                    .background(completeBook.category.themeColor)
                    .clipShape(Circle())
            }
            .buttonRepeatBehavior(.enabled)
            .opacity(lastRecordTotalPagesRead >= totalPagesRead  ? 0.5 : 1)
            .disabled(lastRecordTotalPagesRead >= totalPagesRead  ? true : false)
        }
    }
    
    var plusButton: some View {
        Group {
            let readingBookTotalPages = completeBook.itemPage
            
            Button {
                totalPagesRead  += 1
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(completeBook.category.themeColor)
                    .clipShape(Circle())
            }
            .buttonRepeatBehavior(.enabled)
            .opacity(readingBookTotalPages <= totalPagesRead  ? 0.5 : 1)
            .disabled(readingBookTotalPages <= totalPagesRead  ? true : false)
        }
    }
    
    var renewalButton: some View {
        Button {
            realmManager.addReadingBookRecord(
                completeBook,
                totalPagesRead: totalPagesRead
            )
            readingProgressPage = Double(totalPagesRead)
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
        CompleteBookRenewalSheetView(
            CompleteBook.preview,
            readingProgressPage: .constant(10.0),
            isPresentingReadingBookConfettiView: .constant(false)
        )
        .environmentObject(RealmManager())
    }
}
