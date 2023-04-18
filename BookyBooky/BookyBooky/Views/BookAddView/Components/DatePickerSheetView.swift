//
//  DatePickerSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/14.
//

import SwiftUI
import SwiftDate

struct DatePickerSheetView: View {
    
    @Binding var selectedDate: Date
    let bookInfo: BookInfo.Item
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selected: Date = Date()
    
    var body: some View {
        VStack {
            DatePicker(
                    "DatePicker",
                    selection: $selected,
                    in: Date()...(Date() + 365.days),
                    displayedComponents: [.date]).datePickerStyle(.graphical
                )
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ko"))
                .tint(bookInfo.categoryName.refinedCategory.accentColor)
                .padding(.horizontal)
            
            Button {
                selectedDate = selected
                
                dismiss()
            } label: {
                Text("설정하기")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(bookInfo.categoryName.refinedCategory.foregroundColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(bookInfo.categoryName.refinedCategory.accentColor)
                    .cornerRadius(15)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            selected = selectedDate
        }
        .presentationCornerRadius(30)
        .presentationBackground(.ultraThinMaterial)
        .presentationDetents([.height(460)])
        
    }
}

struct DatePickerSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerSheetView(selectedDate: .constant(Date()), bookInfo: BookInfo.Item.preview[0])
    }
}
