//
//  AddSentenceView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/01.
//

import SwiftUI
import RealmSwift

struct AddSentenceView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var isPresentingKeyboard = true
    
    @State private var inputText: String = ""
    @State private var inputPage: Int = 1
    
    @FocusState private var focusedEditor
    
    // MARK: - PROPERTIES
    
    let placeholder = "문장을 입력하세요. (300자 이내)"
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook) {
        self.readingBook = readingBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $inputText)
                    .frame(height: mainScreen.height * 0.2)
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.darkGray ,lineWidth: 3)
                    }
                    .overlay(alignment: .topLeading) {
                        if inputText.isEmpty {
                            Text(placeholder)
                                .foregroundColor(.secondary)
                                .padding(18)
                        }
                    }
                    .padding(.horizontal)
                    .focused($focusedEditor)
                
                HStack {
                    Text(readingBook.title)
                        .font(.title3.weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .truncationMode(.middle)
                    
                    Spacer()
                    
                    Picker("페이지", selection: $inputPage) {
                        ForEach(1..<readingBook.itemPage) { page in
                            Text("\(page)페이지").tag(page)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("돌아가기")
                    }
                    .buttonStyle(.leftBottomButtonStyle)
                    
                    Button {
                        realmManager.addSentence(readingBook, sentence: inputText, page: inputPage)
                        dismiss()
                    } label: {
                        Text("추가하기")
                    }
                    .buttonStyle(RightBottomButtonStyle(backgroundColor: readingBook.category.accentColor))
                }
                .onReceive(keyboardPublisher) { value in
                    withAnimation {
                        isPresentingKeyboard = value
                    }
                }
                .padding(.bottom, isPresentingKeyboard ? 20 : 0)
            }
            .navigationTitle("수집 문장 추가하기")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationCornerRadius(30)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                focusedEditor = true
            }
        }
    }
}

// MARK: - PREVIEW

struct AddSentenceView_Previews: PreviewProvider {
    static var previews: some View {
        AddSentenceView(ReadingBook.preview)
            .environmentObject(RealmManager())
    }
}
