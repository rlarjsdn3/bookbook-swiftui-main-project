//
//  BookAddCenterView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI

struct AddCompleteBookCenterView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var addCompleteBookViewData: AddCompleteBookViewData
    
    @State private var isPresentingDateDescSheet = false
    @State private var isPresentingDatePickerSheet = false
    
    // MARK: - PROPERTIES
    
    let today = Date()
    
    let book: DetailBookInfo.Item
    
    // MARK: - INTIALIZER
    
    init(_ book: DetailBookInfo.Item) {
        self.book = book
    }
    
    // MARK: - BODY
    
    var body: some View {
        centerArea
            .sheet(isPresented: $isPresentingDatePickerSheet) {
                DatePickerSheetView(theme: book.bookCategory.themeColor)
                    .presentationCornerRadius(30)
                    .presentationDetents([.height(440)])
            }
            .padding(.bottom, 40)
    }
}

// MARK: - EXTENSIONS

extension AddCompleteBookCenterView {
    var centerArea: some View {
        VStack(spacing: 10) {
            LottieBookView()
                .frame(height: 200)
            
            setTargetDateText
            
            selectedTargetDateText
            
            averageDailyReadingPagesLabel
            
            datePickerButton
        }
    }
    
    var setTargetDateText: some View {
        Text("완독 목표일을 설정해주세요.")
            .font(.title3)
            .foregroundColor(.secondary)
    }
    
    var selectedTargetDateText: some View {
        Text("\(addCompleteBookViewData.selectedTargetDate.standardDateFormat)")
            .font(.title)
            .fontWeight(.bold)
    }
    
    var averageDailyReadingPagesLabel: some View {
        Group {
            let dayInterval = today.getDayInterval(to: addCompleteBookViewData.selectedTargetDate)
            let averageDailyReadingPage = book.subInfo.itemPage / dayInterval
            Text("\(dayInterval)일 동안 하루 평균 \(averageDailyReadingPage)페이지를 읽어야 해요.")
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    
    
    var datePickerButton: some View {
        Button {
            isPresentingDatePickerSheet = true
        } label: {
            Text("날짜 변경하기")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(width: 200, height: 35)
                .background(.gray.opacity(0.2), in: .capsule(style: .circular))
        }
        .padding(.top, 20)
    }
}

// MARK: - PREVIEW

#Preview {
    AddCompleteBookCenterView(DetailBookInfo.Item.preview)
        .environmentObject(AddCompleteBookViewData())
}
