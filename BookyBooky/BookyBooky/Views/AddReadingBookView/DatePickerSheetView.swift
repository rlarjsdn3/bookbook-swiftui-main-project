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
    
    // MARK: - PROPERTIES
    
    let accentColor: Color
    @Binding var selectedDate: Date
    
    @State private var selectedDateInSheet: Date
    
    init(accentColor: Color, selectedDate: Binding<Date>) {
        self.accentColor = accentColor
        self._selectedDate = selectedDate
        
        self._selectedDateInSheet = State(initialValue: selectedDate.wrappedValue)
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            DatePicker(
                    "DatePicker",
                    selection: $selectedDateInSheet,
                    in: Date()...Date(timeIntervalSinceNow: 365 * 86_400),
                    displayedComponents: [.date]).datePickerStyle(.graphical
                )
                .tint(accentColor)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ko"))
                .padding()
            
            Button {
                selectedDate = selectedDateInSheet
                dismiss()
            } label: {
                Text("적용하기")
            }
            .buttonStyle(BottomButtonStyle(backgroundColor: accentColor))
        }
        .presentationCornerRadius(30)
        .presentationDetents([.height(420)])
        
    }
}

// MARK: - EXTENSIONS



// MARK: - PREVIEW

struct DatePickerSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerSheetView(accentColor: Color.black, selectedDate: .constant(Date()))
    }
}
