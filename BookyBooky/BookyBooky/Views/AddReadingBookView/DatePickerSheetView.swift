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
    
    @State private var inputDate: Date = Date()
    
    // MARK: - PROPERTIES
    
    let theme: Color
    @Binding var selectedDate: Date
    
    
    init(theme: Color, selectedDate: Binding<Date>) {
        self.theme = theme
        self._selectedDate = selectedDate
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
                selectedDate = inputDate
                dismiss()
            } label: {
                Text("적용하기")
            }
            .buttonStyle(BottomButtonStyle(backgroundColor: theme))
        }
        .onAppear {
            self.inputDate = selectedDate
        }
        .presentationCornerRadius(30)
        .presentationDetents([.height(420)])
        
    }
}

// MARK: - PREVIEW

struct DatePickerSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerSheetView(
            theme: Color.black,
            selectedDate: .constant(Date())
        )
    }
}
