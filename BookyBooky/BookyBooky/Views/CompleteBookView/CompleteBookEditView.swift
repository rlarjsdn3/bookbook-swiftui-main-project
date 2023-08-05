//
//  EditBookInformationView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/10.
//

import SwiftUI
import RealmSwift

struct CompleteBookEditView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmManager: RealmManager
    @EnvironmentObject var alertManager: AlertManager
    
    @State private var inputTitle = ""
    @State private var inputPublisher = ""
    @State private var inputCategory: Category = .all
    @State private var inputTargetDate = Date.now
    @State private var isPresentingKeyboard = false
    
    // MARK: - PROPERTIES
    
    let today = Date()
    let datePickerRange: ClosedRange<Date>
    
    let completeBook: CompleteBook
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook) {
        self.completeBook = completeBook
        
        self.datePickerRange = today.addingDay(1)...today.addingDay(365)
    }
    
    // MARK: - BODY
    
    var body: some View {
        editBookContent
            .onAppear {
                inputTitle = completeBook.title
                inputPublisher = completeBook.publisher
                inputCategory = completeBook.category
                inputTargetDate = completeBook.targetDate
            }
    }
}

// MARK: - EXTENSIONS

extension CompleteBookEditView {
    var editBookContent: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    inputFieldGroup
                }
                .scrollIndicators(.hidden)
                
                editButton
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("도서 정보 수정하기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var inputFieldGroup: some View {
        VStack {
            titleTextField
            
            publisherTextField
            
            categoryField
            
            if !completeBook.isComplete {
                targetDateField
            }
            
            Spacer()
        }
        .padding()
    }
    
    var titleTextField: some View {
        HStack {
            Text("제목")
                .font(.title3.weight(.bold))
                .padding(.trailing, 50)
            TextField("", text: $inputTitle)
        }
        .padding(.vertical, 18)
        .padding(.horizontal)
        .background(Color.customBackground, in: .rect(cornerRadius: 10))
    }
    
    var publisherTextField: some View {
        HStack {
            Text("출판사")
                .font(.title3.weight(.bold))
                .padding(.trailing, 34)
            TextField("", text: $inputPublisher)
        }
        .padding(.vertical, 18)
        .padding(.horizontal)
        .background(Color.customBackground, in: .rect(cornerRadius: 10))
    }
    
    var categoryField: some View {
        HStack {
            Text("카테고리")
                .font(.title3.weight(.bold))
                .padding(.trailing)
            
            Spacer()
            
            Picker("Category Picker", selection: $inputCategory) {
                ForEach(Category.allCases, id: \.self) { category in
                    if category != .all {
                        Text(category.name)
                            .tag(category.name)
                    }
                }
            }
            .labelsHidden()
        }
        .padding(.vertical, 14)
        .padding(.horizontal)
        .background(Color.customBackground, in: .rect(cornerRadius: 10))
    }
    
    var targetDateField: some View {
        HStack {
            Text("목표일자")
                .font(.title3.weight(.bold))
                .padding(.trailing)
            
            Spacer()
            
            DatePicker(
                    "DatePicker",
                    selection: $inputTargetDate,
                    in: datePickerRange,
                    displayedComponents: [.date]
            )
            .labelsHidden()
            .tint(completeBook.category.themeColor)
            .environment(\.locale, Locale(identifier: "ko_kr"))
            .datePickerStyle(.compact)
            .padding(.horizontal, 3)
        }
        .padding(.vertical, 14)
        .padding(.horizontal)
        .background(Color.customBackground, in: .rect(cornerRadius: 10))
    }
    
    var editButton: some View {
        Button {
            realmManager.editReadingBook(
                completeBook,
                title: inputTitle,
                publisher: inputPublisher,
                category: inputCategory,
                targetDate: inputTargetDate
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                dismiss()
            }
            alertManager.isPresentingReadingBookEditSuccessToastAlert = true
        } label: {
            Text("수정하기")
        }
        .onReceive(keyboardPublisher) { value in
            withAnimation {
                isPresentingKeyboard = value
            }
        }
        .buttonStyle(BottomButtonStyle(backgroundColor: Color.black))
        .padding(.bottom, isPresentingKeyboard ? (safeAreaInsets.bottom != 0 ? 10 : -10) : 0)
        .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
    }
}

// MARK: - PREVIEW

#Preview {
    CompleteBookEditView(CompleteBook.preview)
        .environmentObject(RealmManager())
}
