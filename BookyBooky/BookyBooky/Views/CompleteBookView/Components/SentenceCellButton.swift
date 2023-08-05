//
//  SentenceCellButton.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/01.
//

import SwiftUI
import RealmSwift

struct SentenceCellButton: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var isPresentingModifySentenceSheetView = false
    @State private var isPresentingDeleteConfirmationDialog = false
    
    // MARK: - PROPERTIES
    
    let completeBook: CompleteBook
    let sentence: Sentence
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook, sentence: Sentence) {
        self.completeBook = completeBook
        self.sentence = sentence
    }
    
    // MARK: - BODY
    
    var body: some View {
        sentenceButton
            .sheet(isPresented: $isPresentingModifySentenceSheetView) {
                AddSentenceSheetView(completeBook, sentence: sentence)
            }
            .confirmationDialog("해당 문장을 삭제하시겠습니까?", isPresented: $isPresentingDeleteConfirmationDialog, titleVisibility: .visible) {
                Button("삭제", role: .destructive) {
                    realmManager.deleteSentence(completeBook, id: sentence._id)
                }
            }
    }
}

// MARK: - EXTENSIONS

extension SentenceCellButton {
    var sentenceButton: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text(sentence.sentence)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding([.leading, .top, .trailing])
            
            HStack {
                Text(sentence.date.standardDateFormat)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(sentence.page)페이지")
                    .padding(.vertical, 3.2)
                    .padding(.horizontal, 15)
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .background(completeBook.category.themeColor)
                    .clipShape(Capsule())
                    .padding(.trailing)
                
                Menu {
                    Button {
                        isPresentingModifySentenceSheetView = true
                    } label: {
                        Label("수정", systemImage: "square.and.pencil")
                    }
                    
                    Button(role: .destructive) {
                        isPresentingDeleteConfirmationDialog = true
                    } label: {
                        Label("삭제", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.title2)
                        .foregroundColor(completeBook.category.themeColor)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color.customBackground)
    }
}

// MARK: - PREVIEW

#Preview {
    SentenceCellButton(
        CompleteBook.preview,
        sentence: Sentence.preview
    )
    .environmentObject(RealmManager())
}
