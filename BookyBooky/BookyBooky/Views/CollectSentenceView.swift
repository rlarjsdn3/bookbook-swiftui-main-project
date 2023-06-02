//
//  CollectSentenceView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/01.
//

import SwiftUI
import RealmSwift

// 문장 수정 시, 뷰가 새로 그러지는 것에 대해 코드 리팩토링 필요

struct CollectSentenceView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    @State private var isPresentingModifySentenceSheetView = false
    @State private var isPresentingDeleteConfirmationDialog = false
    
    let bookID: ObjectId
    let collectID: ObjectId
    
    var readingBook: ReadingBook {
        readingBooks.findReadingBookFirst(id: bookID)!
    }
    
    var collectSentence: CollectSentences? {
        if let collect = readingBook.collectSentences
            .filter({ $0._id == collectID }).first {
            return collect
        }
        return nil
    }
    
    init(bookID: ObjectId, collectID: ObjectId) {
        self.bookID = bookID
        self.collectID = collectID
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Label(readingBook.title, systemImage: "chevron.left")
                        .frame(width: mainScreen.width * 0.77, alignment: .leading)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .padding(.leading, 25)
                }
                .navigationTitleStyle()
                .buttonStyle(.plain)

                Spacer()
            }
            .overlay {
                HStack {
                    Spacer()
                    
                    Button {
                        isPresentingModifySentenceSheetView = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .navigationBarItemStyle()
                    }
                    .padding([.leading, .trailing], -10)
                    
                    Button {
                        isPresentingDeleteConfirmationDialog = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Color.red)
                            .navigationBarItemStyle()
                    }
                    .padding([.leading], -15)
                }
            }
            .padding(.vertical)
            
            VStack(alignment: .leading) {
                if let collect = collectSentence {
                    Text(collect.sentence)
                        .fontWeight(.bold)
                        .padding(.vertical, 15)
                        .padding(.horizontal)
                    
                    HStack {
                        Text(collect.date.standardDateFormat)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(collect.page)페이지")
                            .padding(.vertical, 3.2)
                            .padding(.horizontal, 15)
                            .font(.caption)
                            .foregroundColor(Color.white)
                            .background(readingBook.category.accentColor)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.background)
            
            Spacer()
        }
        .sheet(isPresented: $isPresentingModifySentenceSheetView) {
            ModifySentenceSheetView(readingBook, collectSentence: collectSentence!)
        }
        .confirmationDialog("해당 문장을 삭제하시겠습니까?", isPresented: $isPresentingDeleteConfirmationDialog, titleVisibility: .visible) {
            Button("삭제", role: .destructive) {
                realmManager.deleteSentence(readingBook, id: collectSentence!._id)
                dismiss()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct CollectSentenceView_Previews: PreviewProvider {
    static var previews: some View {
        CollectSentenceView(bookID: try! ObjectId(string: "123"), collectID: try! ObjectId(string: "123"))
            .environmentObject(RealmManager())
    }
}
