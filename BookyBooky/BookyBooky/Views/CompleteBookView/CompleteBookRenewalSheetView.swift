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
    @EnvironmentObject var completeBookViewData: CompleteBookViewData
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var totalPagesRead = 0
    @State private var isLongPressing: Bool = false
    
    // MARK: - PROPERTIES
    
    let completeBook: CompleteBook
    
    @State var timer: Timer?
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook) {
        self.completeBook = completeBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        renewalContent
            .onAppear {
                totalPagesRead = completeBook.lastRecord?.totalPagesRead ?? 0
            }
            .onDisappear {
                if completeBook.isComplete {
                    completeBookViewData.isPresentingConfettiView = true
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
                    .background(completeBook.category.themeColor, in: .circle)
            }
            .opacity(lastRecordTotalPagesRead >= totalPagesRead  ? 0.5 : 1)
            .disabled(lastRecordTotalPagesRead >= totalPagesRead  ? true : false)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.2)
                    .onEnded { _ in
                        self.isLongPressing = true
                        // 타이머를 실행시켜 0.1초마다 페이지 쪽수가 증가하도록 하기
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            self.totalPagesRead -= 1
                            // 읽은 페이지 수가 마지막으로 읽은 페이지 미만으로 내려간다면
                            if lastRecordTotalPagesRead >= totalPagesRead {
                                timer.invalidate()
                            }
                        }
                    }
                
                // NOTE: - 일반적으로 버튼의 동작은 '눌렀다 떼는 경우' 발생합니다.
                //       - simutaneousGesture를 통해 여러 제스처를 동시에 입력 받으므로,
                //       - 버튼을 0.2초 이상 누르고 있다면 LongPressGesture가 실행(되어 끝나며)되며,
                //       - 그러면 타이머가 실행되어 0.1초마다 페이지 수를 증가시킵니다.
                //       - 이때, 다시 버튼에서 손을 뗀다면, 비로소 그때 버튼의 동작이 실행되며
                //       - isLongPressing에 따라 버튼의 동작이 분기됩니다.
            )
        }
    }
    
    var plusButton: some View {
        Group {
            let readingBookTotalPages = completeBook.itemPage
            
            Button {
                if isLongPressing {
                    isLongPressing = false
                    timer?.invalidate()
                } else {
                    totalPagesRead += 1
                }
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(completeBook.category.themeColor, in: .circle)
            }
            .opacity(readingBookTotalPages <= totalPagesRead  ? 0.5 : 1)
            .disabled(readingBookTotalPages <= totalPagesRead  ? true : false)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.2)
                    .onEnded { _ in
                        self.isLongPressing = true
                        // 타이머를 실행시켜 0.1초마다 페이지 쪽수가 증가하도록 하기
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            self.totalPagesRead += 1
                            // 읽은 페이지 수가 도서 총 페이지를 초과한다면
                            if readingBookTotalPages <= totalPagesRead {
                                timer.invalidate()
                            }
                        }
                    }
                
                // NOTE: - 일반적으로 버튼의 동작은 '눌렀다 떼는 경우' 발생합니다.
                //       - simutaneousGesture를 통해 여러 제스처를 동시에 입력 받으므로,
                //       - 버튼을 0.2초 이상 누르고 있다면 LongPressGesture가 실행(되어 끝나며)되며,
                //       - 그러면 타이머가 실행되어 0.1초마다 페이지 수를 증가시킵니다.
                //       - 이때, 다시 버튼에서 손을 뗀다면, 비로소 그때 버튼의 동작이 실행되며
                //       - isLongPressing에 따라 버튼의 동작이 분기됩니다.
            )
        }
    }
    
    var renewalButton: some View {
        Button {
            realmManager.addReadingBookRecord(
                completeBook,
                totalPagesRead: totalPagesRead
            )
            completeBookViewData.pageProgress = Double(totalPagesRead)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                dismiss()
            }
        } label: {
            Text("갱신하기")
        }
        .buttonStyle(.bottomButtonStyle)
        .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
    }
}

// MARK: - PREVIEW

struct ReadingBookRenewalSheetView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteBookRenewalSheetView(CompleteBook.preview)
            .environmentObject(CompleteBookViewData())
            .environmentObject(RealmManager())
    }
}
