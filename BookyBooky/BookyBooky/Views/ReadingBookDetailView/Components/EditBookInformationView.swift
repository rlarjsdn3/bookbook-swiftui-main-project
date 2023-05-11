//
//  EditBookInformationView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/10.
//

import SwiftUI
import RealmSwift

struct EditBookInformationView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.realm) var realm
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var titleTextField = ""
    @State private var publisherTextField = ""
    @State private var selectedCategory: Category = .all
    @State private var selectedTargetDate = Date.now
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {                
                HStack {
                    Text("제목")
                        .font(.title3.weight(.bold))
                        .padding(.trailing, 50)
                    TextField("", text: $titleTextField)
                }
                .padding(.vertical, 18)
                .padding(.horizontal)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .padding(.top, 20)
                
                HStack {
                    Text("출판사")
                        .font(.title3.weight(.bold))
                        .padding(.trailing, 34)
                    TextField("", text: $publisherTextField)
                }
                .padding(.vertical, 18)
                .padding(.horizontal)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                HStack {
                    Text("카테고리")
                        .font(.title3.weight(.bold))
                        .padding(.trailing)
                    
                    Spacer()
                    
                    Picker("Category Picker", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue)
                        }
                    }
                }
                .padding(.vertical, 14)
                .padding(.horizontal)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                HStack {
                    Text("목표일자")
                        .font(.title3.weight(.bold))
                        .padding(.trailing)
                    
                    Spacer()
                    
                    DatePicker(
                            "DatePicker",
                            selection: $selectedTargetDate,
                            in: Date()...(Calendar.current.date(byAdding: .day, value: 365, to: Date())!),
                            displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ko"))
                        .tint(readingBook.category.accentColor)
                        .padding(.horizontal, 3)
                }
                .padding(.vertical, 14)
                .padding(.horizontal)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    guard let object = realm.object(ofType: ReadingBook.self, forPrimaryKey: readingBook._id) else { return }
                      
                    try! realm.write {
                        object.title = titleTextField
                        object.publisher = publisherTextField
                        object.category = selectedCategory
                        object.targetDate = selectedTargetDate
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dismiss()
                    }
                } label: {
                    Text("수정하기")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(readingBook.category.accentColor)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                // 베젤이 있는 아이폰은 하단 간격 주기
                .padding(safeAreaInsets.bottom == 0 ? .bottom : [])
            }
            .onAppear {
                titleTextField = readingBook.title
                publisherTextField = readingBook.publisher
                selectedCategory = readingBook.category
                selectedTargetDate = readingBook.targetDate
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
            .ignoresSafeArea(.keyboard)
        }
        .presentationCornerRadius(30)
//        .presentationDetents([.height(420)])
    }
}

struct EditBookInformationView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        EditBookInformationView(readingBook: readingBooks[0])
            .environment(\.realm, RealmManager().realm)
    }
}
