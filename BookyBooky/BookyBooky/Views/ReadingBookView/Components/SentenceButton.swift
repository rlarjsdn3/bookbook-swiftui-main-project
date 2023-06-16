//
//  SentenceCellButton.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/01.
//

import SwiftUI
import RealmSwift

enum SentenceCellButtonType {
    case home
    case shelf
}

struct SentenceButton: View {
    
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var isPresentingModifySentenceSheetView = false
    @State private var isPresentingDeleteConfirmationDialog = false
    
    let readingBook: ReadingBook
    let collectSentence: CollectSentences
    
    init(_ readingBook: ReadingBook, collectSentence: CollectSentences) {
        self.readingBook = readingBook
        self.collectSentence = collectSentence
    }
    
    // 문장 상세보기 화면 추가는 보류하기
    
    var body: some View {
        sentenceButton
            .sheet(isPresented: $isPresentingModifySentenceSheetView) {
                ModifySentenceSheetView(readingBook, collectSentence: collectSentence)
            }
            .confirmationDialog("해당 문장을 삭제하시겠습니까?", isPresented: $isPresentingDeleteConfirmationDialog, titleVisibility: .visible) {
                Button("삭제", role: .destructive) {
                    realmManager.deleteSentence(readingBook, id: collectSentence._id)
                }
            }
    }
}

extension SentenceButton {
    var sentenceButton: some View {
        VStack {
            // TODO: - 셀을 클릭하면 자세히 보기 뷰로 이동하도록 만들기
            HStack(alignment: .firstTextBaseline) {
                Text(collectSentence.sentence)
                    .fontWeight(.bold)
                
                Spacer()
                
                //Image(systemName: "chevron.right")
                //    .foregroundColor(.secondary)
            }
            .padding([.leading, .top, .trailing])
            
            HStack {
                Text(collectSentence.date.standardDateFormat)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(collectSentence.page)페이지")
                    .padding(.vertical, 3.2)
                    .padding(.horizontal, 15)
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .background(readingBook.category.themeColor)
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
                        .foregroundColor(readingBook.category.themeColor)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color.background)
    }
}

struct SentenceCellButton_Previews: PreviewProvider {
    static var previews: some View {
        SentenceButton(
            ReadingBook.preview,
            collectSentence: CollectSentences.preview
        )
        .environmentObject(RealmManager())
    }
}
