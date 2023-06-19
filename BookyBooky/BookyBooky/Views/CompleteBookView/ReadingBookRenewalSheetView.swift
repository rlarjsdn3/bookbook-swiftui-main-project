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
    
    @ObservedRealmObject var readingBook: CompleteBook
    @Binding var isPresentingReadingBookConfettiView: Bool
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: CompleteBook, isPresentingReadingBookConfettiView: Binding<Bool>) {
        self.readingBook = readingBook
        self._isPresentingReadingBookConfettiView = isPresentingReadingBookConfettiView
    }
    
    // MARK: - BODY
    
    var body: some View {
        renewalContent
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
            let lastRecordTotalPagesRead = readingBook.lastRecord?.totalPagesRead ?? 0
            
            // TODO: - ‘+’ 혹은 ‘-‘ 버튼을 길게 클릭하면 페이지 수가 감소하거나 증가하도록 업데이트하기
            Button {
                totalPagesRead -= 1
            } label: {
                Image(systemName: "minus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.vertical, 23)
                    .padding(.horizontal)
                    .background(readingBook.category.themeColor)
                    .clipShape(Circle())
            }
            // TODO: -  ‘+’ 혹은 ‘-‘ 버튼을 클릭할 수 없을 때, 흔들기 애니메이션 효과 적용하기
            .opacity(lastRecordTotalPagesRead >= totalPagesRead  ? 0.5 : 1)
            .disabled(lastRecordTotalPagesRead >= totalPagesRead  ? true : false)
        }
    }
    
    var plusButton: some View {
        Group {
            let readingBookTotalPages = readingBook.itemPage
            
            // TODO: - ‘+’ 혹은 ‘-‘ 버튼을 길게 클릭하면 페이지 수가 감소하거나 증가하도록 업데이트하기
            Button {
                totalPagesRead  += 1
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(readingBook.category.themeColor)
                    .clipShape(Circle())
            }
            // TODO: -  ‘+’ 혹은 ‘-‘ 버튼을 클릭할 수 없을 때, 흔들기 애니메이션 효과 적용하기
            .opacity(readingBookTotalPages <= totalPagesRead  ? 0.5 : 1)
            .disabled(readingBookTotalPages <= totalPagesRead  ? true : false)
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
            CompleteBook.preview,
            isPresentingReadingBookConfettiView: .constant(false)
        )
        .environmentObject(RealmManager())
    }
}
