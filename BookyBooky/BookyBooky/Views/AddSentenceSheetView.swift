//
//  AddSentenceView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/01.
//

import SwiftUI
import RealmSwift

// TODO: - ModifySentenceSheetView와 통합 방안 찾아보기 (리팩토링 보류)

struct AddSentenceSheetView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var isPresentingKeyboard = true
    @State private var isPresentingAddConrimationDialog = false
    @State private var isPresentingEditConrimationDialog = false
    
    @State private var inputText: String = ""
    @State private var inputPage: Int = 1
    
    @FocusState private var focusedEditor
    
    // MARK: - PROPERTIES
    
    let characterLimit = 300
    
    let completeBook: CompleteBook
    let sentence: CollectSentences
    let type: ViewType.SentenceSheetView
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook,
         sentence: CollectSentences = .preview,
         type: ViewType.SentenceSheetView) {
        self.completeBook = completeBook
        self.sentence = sentence
        self.type = type
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack {
                editorArea
                
                Spacer()
                
                buttonGroup
            }
            .navigationTitle(type == .new ? "수집 문장 추가하기" : "수집 문장 수정하기")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if type == .modify {
                inputText = sentence.sentence
                inputPage = sentence.page
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focusedEditor = true
            }
        }
        .confirmationDialog("문장이 위치한 페이지가 맞나요? 설정대로 추가하시겠습니까?", isPresented: $isPresentingAddConrimationDialog, titleVisibility: .visible) {
            Button("추가") {
                realmManager.addSentence(completeBook, sentence: inputText, page: inputPage)
                dismiss()
            }
        }
        .confirmationDialog("문장이 위치한 페이지가 맞나요? 설정대로 수정하시겠습니까?", isPresented: $isPresentingEditConrimationDialog, titleVisibility: .visible) {
            Button("수정") {
                modifySentence()
            }
        }
        .presentationCornerRadius(30)
    }
    
    func modifySentence() {
        realmManager.modifySentence(completeBook, id: sentence._id, sentence: inputText, page: inputPage)
        dismiss()
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
                    .strokeBorder(Color.darkGray ,lineWidth: 2)
            }
            .overlay(alignment: .topLeading) {
                if inputText.isEmpty {
                    Text("문장을 입력하세요. (\(characterLimit)자 이내)")
                        .foregroundColor(.secondary)
                        .padding(18)
                }
            }
            .onChange(of: inputText) {
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
        .padding(.bottom, isPresentingKeyboard ? 20 : 0)
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
            switch type {
            case .new:
                Button {
                    if inputPage == 1 {
                        isPresentingAddConrimationDialog = true
                    } else {
                        realmManager.addSentence(completeBook, sentence: inputText, page: inputPage)
                        dismiss()
                    }
                } label: {
                    Text("추가하기")
                }
            case .modify:
                Button {
                    if inputPage == 1 {
                        isPresentingAddConrimationDialog = true
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

struct AddSentenceView_Previews: PreviewProvider {
    static var previews: some View {
        AddSentenceSheetView(CompleteBook.preview, type: .new)
            .environmentObject(RealmManager())
    }
}
