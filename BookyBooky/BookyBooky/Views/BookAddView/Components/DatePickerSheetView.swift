//
//  DatePickerSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/14.
//

import SwiftUI
import SwiftDate

struct DatePickerSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            DatePicker("DatePicker", selection: $selectedDate, in: Date()...(Date() + 128.days), displayedComponents: [.date]).datePickerStyle(.graphical)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ko"))
                .padding()
            
            Button {
                dismiss()
            } label: {
                Text("설정하기")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.black)
                    .cornerRadius(15)
                    .padding(.horizontal)
            }
        }
        .presentationCornerRadius(30)
        .presentationBackground(.ultraThinMaterial)
        .presentationDetents([.height(480)])
        
    }
}

struct DatePickerSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerSheetView()
    }
}
