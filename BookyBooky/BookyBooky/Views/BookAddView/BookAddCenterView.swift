//
//  BookAddCenterView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI
import SwiftDate

struct BookAddCenterView: View {
    
    // MARK: - COMPUTED PROPERTIES
    
    var dayInterval: Int {
        return Int(round(selectedDate.timeIntervalSince(Date()) / 86_400.0))
    }
    
    // MARK: - PROPERTIES
    
    let bookInfoItem: BookInfo.Item
    @Binding var selectedDate: Date
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isPresentingDateDescSheet = false
    @State private var isPresentingDatePickerSheet = false
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 10) {
            targetDateLabel
            
            targetSelectedDateLabel
            
            averageDailyReadingPageLabel
            
            selectDateMenu
        }
        .sheet(isPresented: $isPresentingDatePickerSheet) {
            DatePickerSheetView(selectedDate: $selectedDate, bookInfo: bookInfoItem)
        }
        .padding(.bottom, 40)
    }
}

// MARK: - EXTENSIONS

extension BookAddCenterView {
    var targetDateLabel: some View {
        HStack {
            Text("완독 목표일을 설정해주세요.")
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
    
    var targetSelectedDateLabel: some View {
        Text("\(selectedDate.toFormat("yyyy년 MM월 dd일 (E)", locale: Locale(identifier: "ko")))")
            .font(.title)
            .fontWeight(.bold)
    }
    
    var averageDailyReadingPageLabel: some View {
        Group {
            if dayInterval != 0 {
                Text("\(dayInterval)일 동안 하루 평균 \(String(format: "%d",  Double(bookInfoItem.subInfo.itemPage) / Double(dayInterval)))페이지를 읽어야 해요.")
            } else {
                Text("오늘까지 \(bookInfoItem.subInfo.itemPage)페이지를 읽어야 해요.")
            }
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    
    
    var selectDateMenu: some View {
        Menu {
            // do something...
        } label: {
            Text("날짜 변경하기")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(width: 200, height: 35)
                .background(.gray.opacity(0.2))
                .clipShape(Capsule(style: .circular))
        } primaryAction: {
            isPresentingDatePickerSheet = true
        }
        .padding(.top, 20)
    }
}

// MARK: - PREVIEW

struct BookAddCenterView_Previews: PreviewProvider {
    static var previews: some View {
        BookAddCenterView(bookInfoItem: BookInfo.Item.preview[0], selectedDate: .constant(Date()))
    }
}
