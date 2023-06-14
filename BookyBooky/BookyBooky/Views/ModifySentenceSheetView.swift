//
//  ModifySentenceSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/02.
//

import SwiftUI
import RealmSwift

// AddSentenceSheetView와 통합하는 방안 고민할 필요가 있음

struct ModifySentenceSheetView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var isPresentingKeyboard = true
    @State private var isPresentingAddConrimationDialog = false
    
    @State private var inputText: String = ""
    @State private var inputPage: Int = 1
    
    @FocusState private var focusedEditor
    
    // MARK: - PROPERTIES
    
    let characterLimit = 300
    
    let readingBook: ReadingBook
    let collectSentence: CollectSentences
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook, collectSentence: CollectSentences) {
        self.readingBook = readingBook
        self.collectSentence = collectSentence
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
                            Text("문장을 입력하세요. (\(characterLimit)자 이내)")
                                .foregroundColor(.secondary)
                                .padding(18)
                        }
                    }
                    .onChange(of: inputText) { newText in
                        if newText.count > characterLimit {
                            inputText = String(inputText.prefix(characterLimit))
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
                        if inputPage == 1 {
                            isPresentingAddConrimationDialog = true
                        } else {
                            modifySentence()
                        }
                    } label: {
                        Text("수정하기")
                    }
                    .disabled(inputText.isEmpty)
                    .buttonStyle(RightBottomButtonStyle(backgroundColor: readingBook.category.themeColor))
                }
                .onReceive(keyboardPublisher) { value in
                    withAnimation {
                        isPresentingKeyboard = value
                    }
                }
                .padding(.bottom, isPresentingKeyboard ? 20 : 0)
            }
            .navigationTitle("수집 문장 수정하기")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            inputText = collectSentence.sentence
            inputPage = collectSentence.page
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                focusedEditor = true
            }
        }
        .confirmationDialog("문장이 위치한 페이지가 맞나요? 설정대로 수정하시겠습니까?", isPresented: $isPresentingAddConrimationDialog, titleVisibility: .visible) {
            Button("수정") {
                modifySentence()
            }
        }
        .presentationCornerRadius(30)
    }
    
    func modifySentence() {
        realmManager.modifySentence(readingBook, id: collectSentence._id, sentence: inputText, page: inputPage)
        dismiss()
    }
}

// MARK: - PREVIEW

struct ModifySentenceView_Previews: PreviewProvider {
    static var previews: some View {
        ModifySentenceSheetView(
            ReadingBook.preview,
            collectSentence: CollectSentences.preview
        )
        .environmentObject(RealmManager())
    }
}
