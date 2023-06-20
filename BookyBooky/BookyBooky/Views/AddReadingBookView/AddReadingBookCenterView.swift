//
//  BookAddCenterView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI

struct AddReadingBookCenterView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isPresentingDateDescSheet = false
    @State private var isPresentingDatePickerSheet = false
    
    // MARK: - COMPUTED PROPERTIES
    
    var dayInterval: Int? {
        let today = Date.now
        let calendar = Calendar.current
        let interval = calendar.dateComponents([.day], from: today, to: selectedDate)
        return interval.day
    }
    
    // MARK: - PROPERTIES
    
    let bookItem: detailBookInfo.Item
    @Binding var selectedDate: Date
    
    // MARK: - INTIALIZER
    
    init(_ bookItem: detailBookInfo.Item, selectedDate: Binding<Date>) {
        self.bookItem = bookItem
        self._selectedDate = selectedDate
    }
    
    // MARK: - BODY
    
    var body: some View {
        centerLabel
            .sheet(isPresented: $isPresentingDatePickerSheet) {
                DatePickerSheetView(
                    theme: bookItem.bookCategory.themeColor,
                    selectedDate: $selectedDate)
            }
            .padding(.bottom, 40)
    }
}

// MARK: - EXTENSIONS

extension AddReadingBookCenterView {
    var centerLabel: some View {
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
        Text("\(selectedDate.standardDateFormat)")
            .font(.title)
            .fontWeight(.bold)
    }
    
    var averageDailyReadingPagesLabel: some View {
        Group {
            if let dayInterval = dayInterval {
                let day = dayInterval + 1
                let averageDailyReadingPages = bookItem.subInfo.itemPage / day
                Text("\(day)일 동안 하루 평균 \(averageDailyReadingPages)페이지를 읽어야 해요.")
            }
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

struct BookAddCenterView_Previews: PreviewProvider {
    static var previews: some View {
        AddReadingBookCenterView(
            detailBookInfo.Item.preview,
            selectedDate: .constant(Date())
        )
    }
}
