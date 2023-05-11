//
//  DatePickerSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/14.
//

import SwiftUI

struct DatePickerSheetView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var selectedDate: Date
    let bookInfo: BookInfo.Item
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selected: Date = Date()
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            Spacer()
            
            DatePicker(
                    "DatePicker",
                    selection: $selected,
                    in: Date()...(Calendar.current.date(byAdding: .day, value: 365, to: Date.now)!),
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
                    .foregroundColor(.white)
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
        .presentationDetents([.height(420)])
        
    }
}

// MARK: - EXTENSIONS



// MARK: - PREVIEW

struct DatePickerSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerSheetView(selectedDate: .constant(Date()), bookInfo: BookInfo.Item.preview[0])
    }
}
