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
    @EnvironmentObject var completeBookViewData: CompleteBookViewData
    
    @State private var totalPageRead = 0
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
                totalPageRead = completeBook.lastRecord?.totalPagesRead ?? 0
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

// MARK: - EXTENSIONS

extension CompleteBookRenewalSheetView {
    var renewalContent: some View {
        VStack {
            titleText
            
            Spacer()
        
            totalPageReadLabel
            
            Spacer()
            
            renewalButton
        }
    }
    
    var titleText: some View {
        Text("어디까지 읽으셨나요?")
            .font(.title.weight(.bold))
            .padding(.top, 45)
    }
    
    var totalPageReadLabel: some View {
        VStack {
            Text("\(totalPageRead)")
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
            let previousPageRead = completeBook.lastRecord?.totalPagesRead ?? 0
            
            Button {
                totalPageRead -= 1
            } label: {
                Image(systemName: "minus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.vertical, 23)
                    .padding(.horizontal)
                    .background(completeBook.category.themeColor, in: .circle)
            }
            .opacity(previousPageRead >= totalPageRead  ? 0.5 : 1)
            .disabled(previousPageRead >= totalPageRead  ? true : false)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.2)
                    .onEnded { _ in
                        self.isLongPressing = true
                        // 타이머를 실행시켜 0.1초마다 페이지 쪽수가 증가하도록 하기
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            self.totalPageRead -= 1
                            // 읽은 페이지 수가 마지막으로 읽은 페이지 미만으로 내려간다면
                            if previousPageRead >= totalPageRead {
                                timer.invalidate()
                            }
                        }
                    }
                
                // NOTE: - 일반적으로 버튼의 동작은 '눌렀다 떼는 경우' 발생합니다.
                //       - simutaneousGesture를 통해 여러 제스처를 동시에 입력 받으므로,
                //       - 버튼을 0.2초 이상 누르고 있다면 LongPressGesture가 실행(되어 끝나며)되며,
                //       - 그러면 타이머가 실행되어 0.1초마다 페이지 수를 감소시킵니다.
                //       - 이때, 다시 버튼에서 손을 뗀다면, 비로소 그때 버튼의 동작이 실행되며
                //       - isLongPressing에 따라 버튼의 동작이 분기됩니다.
            )
        }
    }
    
    var plusButton: some View {
        Group {
            let totalPage = completeBook.itemPage
            
            Button {
                if isLongPressing {
                    isLongPressing = false
                    timer?.invalidate()
                } else {
                    totalPageRead += 1
                }
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(completeBook.category.themeColor, in: .circle)
            }
            .opacity(totalPage <= totalPageRead  ? 0.5 : 1)
            .disabled(totalPage <= totalPageRead  ? true : false)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.2)
                    .onEnded { _ in
                        self.isLongPressing = true
                        // 타이머를 실행시켜 0.1초마다 페이지 쪽수가 증가하도록 하기
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            self.totalPageRead += 1
                            // 읽은 페이지 수가 도서 총 페이지를 초과한다면
                            if totalPage <= totalPageRead {
                                timer.invalidate()
                            }
                        }
                    }
            )
        }
    }
    
    var renewalButton: some View {
        Button {
            realmManager.addReadingBookRecord(
                completeBook,
                totalPagesRead: totalPageRead
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                dismiss()
            }
            completeBookViewData.pageRead = Double(totalPageRead)
        } label: {
            Text("갱신하기")
        }
        .buttonStyle(.bottomButtonStyle)
        .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
    }
}

// MARK: - PREVIEW

#Preview {
    CompleteBookRenewalSheetView(CompleteBook.preview)
        .environmentObject(CompleteBookViewData())
        .environmentObject(RealmManager())
}
