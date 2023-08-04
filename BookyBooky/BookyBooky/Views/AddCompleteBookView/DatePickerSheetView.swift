//
//  DatePickerSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/14.
//

import SwiftUI

struct DatePickerSheetView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var addCompleteBookViewData: AddCompleteBookViewData
    
    @State private var inputDate: Date = Date()
    
    // MARK: - PROPERTIES
    
    let today = Date()
    let datePickerRange: ClosedRange<Date>
    
    let theme: Color
    
    // MARK: - INTIALIZER
    
    init(theme: Color) {
        self.theme = theme
        
        datePickerRange = today.addingDay(1)...today.addingDay(365)
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            DatePicker(
                "DatePicker",
                selection: $inputDate,
                in: datePickerRange,
                displayedComponents: [.date]).datePickerStyle(.graphical
            )
            .tint(theme)
            .labelsHidden()
            .padding()
            
            Button {
                addCompleteBookViewData.selectedTargetDate = inputDate
                dismiss()
            } label: {
                Text("적용하기")
            }
            .buttonStyle(BottomButtonStyle(backgroundColor: theme))
        }
        .onAppear {
            self.inputDate = addCompleteBookViewData.selectedTargetDate
        }
        .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
    }
}

// MARK: - PREVIEW

#Preview {
    DatePickerSheetView(theme: Color.black)
        .environmentObject(AddCompleteBookViewData())
}
