//
//  AddSentenceView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/01.
//

import SwiftUI
import RealmSwift

struct AddSentenceSheetView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmManager: RealmManager
    @EnvironmentObject var alertManager: AlertManager
    
    @State private var isPresentingKeyboard = true
    @State private var isPresentingAddConrimationDialog = false
    @State private var isPresentingModifyConrimationDialog = false
    
    @State private var inputText: String = ""
    @State private var inputPage: Int = 1
    
    @FocusState private var focusedEditor
    
    // MARK: - PROPERTIES
    
    let characterLimit = 300
    
    let completeBook: CompleteBook
    let sentence: Sentence?
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook, sentence: Sentence? = nil) {
        self.completeBook = completeBook
        self.sentence = sentence
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack {
                editorArea
                
                Spacer()
                
                buttonGroup
            }
            .navigationTitle(sentence == nil ? "수집 문장 추가하기" : "수집 문장 수정하기")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            inputText = sentence?.sentence ?? ""
            inputPage = sentence?.page ?? 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focusedEditor = true
            }
        }
        .confirmationDialog("문장이 위치한 페이지가 맞나요? 설정대로 추가하시겠습니까?", isPresented: $isPresentingAddConrimationDialog, titleVisibility: .visible) {
            Button("추가") {
               addSentence()
            }
        }
        .confirmationDialog("문장이 위치한 페이지가 맞나요? 설정대로 수정하시겠습니까?", isPresented: $isPresentingModifyConrimationDialog, titleVisibility: .visible) {
            Button("수정") {
                modifySentence()
            }
        }
    }
    
    func addSentence() {
        realmManager.addSentence(completeBook, sentence: inputText, page: inputPage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismiss()
        }
        alertManager.isPresentingAddSentenceSuccessToastAlert = true
    }
    
    func modifySentence() {
        realmManager.modifySentence(
            completeBook,
            id: sentence!._id,
            sentence: inputText,
            page: inputPage
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismiss()
        }
        alertManager.isPresentingReadingBookRenewalSuccessToastAlert = true
    }
}

// MARK: - EXTENSIONS

extension AddSentenceSheetView {
    var editorArea: some View {
        VStack {
            textEditor
            
            HStack {
                bookTitleText
                
                Spacer()
                
                pagePicker
            }
        }
        .padding()
    }
    
    var textEditor: some View {
        TextEditor(text: $inputText)
            .frame(height: mainScreen.height * 0.2)
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.customDarkGray ,lineWidth: 2)
            }
            .overlay(alignment: .topLeading) {
                if inputText.isEmpty {
                    Text("문장을 입력하세요. (\(characterLimit)자 이내)")
                        .foregroundColor(.secondary)
                        .padding(18)
                }
            }
            .onChange(of: inputText) { _ in
                if inputText.count > characterLimit {
                    inputText = String(inputText.prefix(characterLimit))
                }
            }
            .focused($focusedEditor)
    }
    
    var bookTitleText: some View {
        Text(completeBook.title)
            .font(.title3.weight(.bold))
            .lineLimit(1)
            .truncationMode(.middle)
    }
    
    var pagePicker: some View {
        Picker("페이지", selection: $inputPage) {
            ForEach(1..<completeBook.itemPage) { page in
                Text("\(page)페이지")
                    .tag(page)
            }
        }
    }
    
    var buttonGroup: some View {
        HStack {
            backButton
            
            addButton
        }
        .onReceive(keyboardPublisher) { value in
            withAnimation {
                isPresentingKeyboard = value
            }
        }
        .padding(.bottom, isPresentingKeyboard ? (safeAreaInsets.bottom != 0 ? 20 : -10) : 0)
        .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Text("돌아가기")
        }
        .buttonStyle(.leftBottomButtonStyle)
    }
    
    var addButton: some View {
        Group {
            if sentence == nil {
                Button {
                    if inputPage == 1 {
                        isPresentingAddConrimationDialog = true
                    } else {
                        addSentence()
                    }
                } label: {
                    Text("추가하기")
                }
            } else {
                Button {
                    if inputPage == 1 {
                        isPresentingModifyConrimationDialog = true
                    } else {
                        modifySentence()
                    }
                } label: {
                    Text("수정하기")
                }
            }
        }
        .disabled(inputText.isEmpty)
        .buttonStyle(RightBottomButtonStyle(backgroundColor: completeBook.category.themeColor))
    }
}

// MARK: - PREVIEW

struct AddSentenceSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddSentenceSheetView(CompleteBook.preview)
            .environmentObject(RealmManager())
            .environmentObject(AlertManager())
    }
}
