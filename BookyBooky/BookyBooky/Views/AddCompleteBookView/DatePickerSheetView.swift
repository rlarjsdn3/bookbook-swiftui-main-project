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
    
    let theme: Color
    
    
    init(theme: Color) {
        self.theme = theme
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            DatePicker(
                "DatePicker",
                selection: $inputDate,
                in: Date(timeIntervalSinceNow: 86_400)...Date(timeIntervalSinceNow: 365 * 86_400),
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

struct DatePickerSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerSheetView(theme: Color.black)
            .environmentObject(AddCompleteBookViewData())
    }
}
