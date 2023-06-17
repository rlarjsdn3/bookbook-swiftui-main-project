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
    
    var dayInterval: Int {
        return Int(round(selectedDate.timeIntervalSince(Date()) / 86_400.0))
    }
    
    // MARK: - PROPERTIES
    
    let bookInfo: detailBookInfo.Item
    @Binding var selectedDate: Date
    
    // MARK: - INTIALIZER
    
    init(_ bookInfo: detailBookInfo.Item, selectedDate: Binding<Date>) {
        self.bookInfo = bookInfo
        self._selectedDate = selectedDate
    }
    
    // MARK: - BODY
    
    var body: some View {
        centerLabel
            .sheet(isPresented: $isPresentingDatePickerSheet) {
                DatePickerSheetView(
                    accentColor: bookInfo.bookCategory.themeColor,
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
            
            averageDailyPageLabel
            
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
    
    var averageDailyPageLabel: some View {
        Group {
            if dayInterval != 0 {
                Text("\(dayInterval)일 동안 하루 평균 \(String(format: "%.0f",  Double(bookInfo.subInfo.itemPage) / Double(dayInterval)))페이지를 읽어야 해요.")
            } else {
                Text("오늘까지 \(bookInfo.subInfo.itemPage)페이지를 읽어야 해요.")
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
