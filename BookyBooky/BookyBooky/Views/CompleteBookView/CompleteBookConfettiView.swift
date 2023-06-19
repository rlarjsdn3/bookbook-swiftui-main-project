//
//  CompleteConfettiView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/15.
//

import SwiftUI
import RealmSwift
import ConfettiSwiftUI

struct CompleteBookConfettiView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @State private var counter = 0
    
    // MARK: - COMPUTED PROPERTIES
    
    var dayToCompleteTheBook: Int {
        let component = Calendar.current.dateComponents(
            [.day],
            from: completeBook.startDate,
            to: completeBook.completeDate ?? Date()
        )
        return component.day!
    }
    
    var dayRemainingUntilTheTargetDate: Int {
        let component = Calendar.current.dateComponents(
            [.day],
            from: completeBook.completeDate ?? Date(),
            to: completeBook.targetDate
        )
        return component.day!
    }
    
    // MARK: - PROPERTIES
    
    let completeBook: CompleteBook
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook) {
        self.completeBook = completeBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        confettiContent
            .confettiCannon(
                counter: $counter, num: 50,
                openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360),
                radius: 200, repetitions: 3, repetitionInterval: 0.5
            )
            .onTapGesture {
                counter += 1
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    HapticManager.shared.notification(type: .success)
                    counter += 1
                }
            }
    }
}

extension CompleteBookConfettiView {
    var confettiContent: some View {
        VStack {
            Spacer()
            
            congratuationLabel
            
            asyncCoverImage(
                completeBook.cover,
                coverShape: RoundedRect()
            )
            
            timeToCompleteBookText
            
            Spacer()
            
            okButton
        }
    }
    
    var congratuationLabel: some View {
        VStack(spacing:5 ) {
            Text("축하합니다!")
                .font(.largeTitle.weight(.bold))
            
            Text("\(completeBook.title) 도서를 완독했어요!")
                .font(.title2.weight(.semibold))
                .foregroundColor(Color.secondary)
        }
        .padding(.bottom, 40)
    }
    
    var timeToCompleteBookText: some View {
        Group {
            let dayToCompleteTheReading = dayToCompleteTheBook
            let dayRemainingUntilTheTargetDate = dayRemainingUntilTheTargetDate
            
            if dayToCompleteTheReading == 0 {
                Text("와우! 하루 만에 독서를 끝냈어요!")
            } else {
                HStack(spacing: 10) {
                    Text("완독하는 데 \(dayRemainingUntilTheTargetDate)일이 걸렸어요.")
                    
                    Text("목표보다 \(dayRemainingUntilTheTargetDate)일 더 빠르게 읽었어요!")
                }
            }
        }
        .font(.headline)
        .foregroundColor(Color.secondary)
        .padding(.top, 30)
    }
    
    var okButton: some View {
        Button {
            dismiss()
        } label: {
             Text("확인")
        }
        .buttonStyle(BottomButtonStyle(backgroundColor: completeBook.category.themeColor))
    }
}

struct CompleteConfettiView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteBookConfettiView(CompleteBook.preview)
    }
}
